async        = require "async"
_            = require "underscore"
utils        = require("./objects/utils")
User         = require("./objects/user").User
Repo         = require("./objects/repo").Repo
Tree         = require("./objects/tree").Tree
Blob         = require("./objects/blob").Blob
TreeEntry    = require("./objects/tree.entry").TreeEntry
Commit       = require("./objects/commit").Commit

ReposDao     = require "./dao/repos.dao"
UsersDao     = require "./dao/users.dao"
CommitsDao   = require "./dao/commits.dao"
TreesDao     = require "./dao/trees.dao"
BlobsDao     = require "./dao/blobs.dao"

MassiveGit = exports.MassiveGit = class MassiveGit

  constructor: (@log = false) ->
    @reposDao = ReposDao.newInstance()
    @usersDao = UsersDao.newInstance()
    @commitsDao = CommitsDao.newInstance()
    @treesDao = TreesDao.newInstance()
    @blobsDao = BlobsDao.newInstance()

  newUser: (username, email, callback) =>
    user = new User username, email
    @usersDao.save user, callback

  initRepo: (name, author, type, callback) =>
    if !name? or !author?
      err =
        message: "Invalid parameters"
        statusCode: 422
      callback err
    else
      repo = new Repo(name, author, type)
      @reposDao.exists repo.id(), (err, exists) =>
        if(err)
          err.statusCode = 400
          err.message = "Internal error"
          callback err
        if(exists)
          err =
            statusCode: 422
            message: "Repo already exists"
          callback err
        else
          @_saveRepo repo, callback

  forkRepo: (repoId, name, author, callback) =>
    @getRepo repoId, (err, repo) =>
      if(err)
        callback err
      else
        forkedRepo = repo.fork name, author
        @_saveRepo forkedRepo, callback

  _saveRepo: (repo, callback) =>
    @reposDao.save repo, (err, ok) =>
      if(err)
        err.message = "Repo wasn't found"
        callback err
      else
        @usersDao.addRepo repo.author, repo.id(), repo.type, (err, ok) ->
          if(err)
            err.statusCode = 400
            err.message = "User wasn't found"
            callback err
          else
            callback undefined, repo


  deleteRepo: (repoId, author, type, callback) =>
    @reposDao.delete repoId, (err, ok) =>
      if(err)
        err.statusCode = 400
        err.message = "Repo wasn't found"
        callback err
      else
        @usersDao.removeRepo author, repoId, type, (err, ok) ->
          if(err)
            err.message = "User wasn't found"
            callback err
          else
            callback undefined, ok

  getUserRepos: (user, type, callback) => @usersDao.findAllRepos user, type, callback

  getNewestRepos: (callback) => @reposDao.getNewestRepos callback

  searchRepos: (name, author, callback) => @reposDao.search name, author, callback

  getUserReposEntries: (user, type, callback) => @usersDao.fetchAllRepos user, type, callback

  commit: (entries, repoId, author, message = "initial commit", parentCommit = undefined, callback) =>
    preparedEntries = @_prepareEntries entries, repoId
    tasks = preparedEntries.tasks
    treeEntries = preparedEntries.treeEntries
    @_prepareTreeAndCommit treeEntries, repoId, parentCommit, author, message, tasks, callback

  addToIndex: (entries, repoId, author, message = "update", callback) =>
    @getHeadTree repoId, (err, tree, commitId) =>
      if(err)
        callback err
      else
        preparedEntries =  @_prepareEntries entries, repoId
        newEntries = preparedEntries.treeEntries
        tasks = preparedEntries.tasks
        date = new Date().getTime()
        mergedEntries = tree.entries
        console.log "Entries for commit", newEntries, mergedEntries
        newEntriesNames = (entry.name for entry in newEntries)
        console.log "Entries names>>", newEntriesNames
        mergedEntries = _.reject mergedEntries, (entry) -> _.include newEntriesNames, entry.name
        utils.mergeArrays mergedEntries, newEntries
        console.log "merged entries", mergedEntries
        @_prepareTreeAndCommit mergedEntries, repoId, commitId, author, message, tasks, callback

  _prepareTreeAndCommit: (treeEntries, repoId, parentCommit, author, message, tasks, callback) =>
    date = new Date().getTime()
    root = new Tree(treeEntries, repoId)
    commit = new Commit(root.id(), parentCommit, author, date, author, date, message, repoId)
    tasks.push async.apply @treesDao.save, root
    tasks.push async.apply @commitsDao.save, commit
    tasks.push async.apply @_updateRepoCommitRef, repoId, commit.id()
    # todo (anton) for some reason when we use parallel my riak server can crash. Investigate this.
    async.series tasks, (err, results) ->
      callback err, commit.id()


  _updateRepoCommitRef: (repoId, commitId, callback) =>
    @getRepo repoId, (err, repo) =>
      if(err)
        callback err
      else
        repo.commit = commitId
        @reposDao.save repo, callback

  # Callback takes 3 parameters: err, entries and repo instance.
  fetchRepoRootEntriesById: (repoId, callback) =>
    @getHead repoId, (err, commitId, repo) =>
      if(err)
        callback err
      else
        @fetchRootEntriesForCommit commitId, (err, entries) ->
          if(err)
            callback err
          else
            callback undefined, entries, repo

  # Callback takes 3 parameters: err, commit id and repo instance.
  getHead: (repoId, callback) =>
   @getRepo repoId, (err, repo) ->
      if(err)
        callback err
      else
        callback undefined, repo.commit, repo

  # Callback accepts 3 parameters: error, tree and commit id.
  getHeadTree: (repoId, callback) =>
    @getHead repoId, (err, commitId) =>
      if(err)
        callback err
      else
        @getHeadTreeFromCommit commitId, callback

  # Callback accepts 3 parameters: error, tree and commit id.
  getHeadTreeFromCommit: (commitId, callback) =>
    @getCommit commitId, (err, commit) =>
      if(err)
        callback err
      else
        treeId = commit.tree
        @getTree treeId, (err, tree) ->
          if(err)
            callback err
          else
            callback undefined, tree,commitId

  fetchRootEntriesForCommit: (commitId, callback) =>
    @getHeadTreeFromCommit commitId,(err, tree) =>
      if(err)
        callback err
      else
        @getBlobs tree.id(), (err, blobs) ->
          if(err)
            callback err
          else
            entries = tree.entries
            treeEntries = []
            for blob in blobs
              blobId = blob.id()
              name = entry.name for entry in entries when entry.id == blobId
              treeEntries.push new TreeEntry name, blob
            callback err, treeEntries


  _prepareEntries: (entries, repoId) =>
    plainEntries = []
    tasks = []
    for entry in entries
      plainEntries.push entry.attributes()
      # todo (anton) trees can be added later
      if(entry.entry.type == "blob")
        blob = entry.entry
        blob.repo = repoId
        # todo (anton) we can use dao.exists() before saving each blob.
        task = async.apply @blobsDao.save, blob
        tasks.push task
    {tasks: tasks, treeEntries: plainEntries}

  getHistoryForRepo: (repoId, callback) =>
    @getHead repoId, (err, commitId) =>
      if(err)
        callback err
      else
        @getHistoryForCommit commitId, callback

  getHistoryForCommit: (commitId, callback) =>
    @commitsDao.getParents commitId, callback

  getBlobs: (treeId, callback) =>
    @treesDao.getBlobs treeId, (err, blobs) ->
      if(err)
        err.message = "Cannot retrive blobs"
        callback err
      else
        callback undefined, blobs

  getRepo: (id, callback) =>
    if(!id)
      callback {statusCode: 422, message: "Invalid parameters"}
    else
      @reposDao.get id, (err, repo) ->
        if(err)
          err.statusCode = 400
          err.message = "Repo wasn't found"
          callback err
        else
          callback undefined, repo

  getBlob: (id, callback) =>
    if(!id)
      callback {statusCode: 422, message: "Invalid parameters"}
    else
      @blobsDao.get id, (err, blob) ->
        if(err)
          err.statusCode = 400
          err.message = "Blob wasn't found"
          callback err
        else
          callback undefined, blob

  getCommit: (id, callback) =>
    if(!id)
      callback {statusCode: 422, message: "Invalid parameters"}
    else
      @commitsDao.get id, (err, commit) ->
        if(err)
          err.statusCode = 400
          err.message = "Commit wasn't found"
        else
          callback undefined, commit

  getTree: (id, callback) =>
    if(!id)
      callback {statusCode: 422, message: "Invalid parameters"}
    else
      @treesDao.get id, (err, commit) ->
        if(err)
          err.statusCode = 400
          err.message = "Tree wasn't found"
        else
          callback undefined, commit

  # Factory method to deal with Git Objects
  # --------------
  # create new tree entry.
  createTreeEntry: (name, data) => new TreeEntry name, @createBlob(data)

  # Create new with provided data.
  createBlob: (data) -> new Blob data

