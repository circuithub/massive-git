async        = require "async"
_            = require "underscore"
sanitize     = require("validator").sanitize
validators   = require "./validators/input.validators"
utils        = require("./objects/utils")

# Dao objects
ReposDao     = require "./dao/repos.dao"
UsersDao     = require "./dao/users.dao"
CommitsDao   = require "./dao/commits.dao"
TreesDao     = require "./dao/trees.dao"
BlobsDao     = require "./dao/blobs.dao"

# Re-export objects.
User = exports.User = require("./objects/user").User
Repo = exports.Repo = require("./objects/repo").Repo
Tree = exports.Tree = require("./objects/tree").Tree
Blob = exports.Blob = require("./objects/blob").Blob
Commit = exports.Commit = require("./objects/commit").Commit
TreeEntry = exports.TreeEntry = require("./objects/tree.entry").TreeEntry


MassiveGit = exports.MassiveGit = class MassiveGit

  constructor: (@log = false) ->
    @reposDao = ReposDao.newInstance()
    @usersDao = UsersDao.newInstance()
    @commitsDao = CommitsDao.newInstance()
    @treesDao = TreesDao.newInstance()
    @blobsDao = BlobsDao.newInstance()

  newUser: (username, email, callback) =>
    validationResult = validators.validateUser(username, email)
    if !validationResult.isValid()
      err =
        statusCode: 422
        message: validationResult.errorMessage
      callback err
    else
      # create user object and save it
      [username, email] = validationResult.sanitizedParameters
      user = new User username, email
      console.log "user to be created", user, validationResult
      @usersDao.exists user.id(), (err, exists) =>
        if err
          err.statusCode = 400
          err.message = "Internal error"
          callback err
        if exists
          err =
            statusCode: 422
            message: "User already exists"
          callback err
        else
          @usersDao.save user, callback

  initRepo: (name, author, type, callback) =>
    validationResult = validators.validateRepo(name, author)
    if !validationResult.isValid()
      err =
        statusCode: 422
        message: validationResult.errorMessage
      callback err
    else
      # create repo object and save it
      [name, author] = validationResult.sanitizedParameters
      repo = new Repo(name, author, type)
      @reposDao.exists repo.id(), (err, exists) =>
        if err
          err.statusCode = 400
          err.message = "Internal error"
          callback err
        if exists
          err =
            statusCode: 422
            message: "Repo already exists"
          callback err
        else
          @_saveRepo repo, callback

  forkRepo: (repoId, name, author, callback) =>
    @getRepo repoId, (err, repo) =>
      if err
        callback err
      else
        forkedRepo = repo.fork name, author
        @_saveRepo forkedRepo, callback

  _saveRepo: (repo, callback) =>
    @reposDao.save repo, (err, ok) =>
      if err
        err.message = "Repo wasn't found"
        callback err
      else
        @usersDao.addRepo repo.author, repo.id(), repo.type, (err, ok) ->
          if err
            err.statusCode = 400
            err.message = "User wasn't found"
            callback err
          else
            callback undefined, repo

  deleteRepo: (repoId, author, callback) =>
    @reposDao.remove repoId, (err, ok) =>
      if err
        err.statusCode = 400
        err.message = "Repo wasn't found"
        callback err
      else
        @usersDao.removeRepo author, repoId, (err, ok) ->
          if err
            err.message = "User wasn't found"
            callback err
          else
            callback undefined, ok

  getUserRepos: (user, callback) => @searchRepos undefined, user, callback

  getNewestRepos: (callback) => @reposDao.getNewestRepos callback

  searchRepos: (name, author, callback) => @reposDao.search name, author, callback

  getUserReposEntries: (user, callback) => @usersDao.fetchAllRepos user, callback

  commit: (entries, repoId, author, message = "initial commit", parentCommit = undefined, callback) =>
    preparedEntries = @_prepareEntries entries, repoId
    tasks = preparedEntries.tasks
    treeEntries = preparedEntries.treeEntries
    async.series tasks, (err, results) =>
      if err
        callback err
      else
        @_prepareTreeAndCommit treeEntries, repoId, parentCommit, author, message, callback

  addToIndex: (entries, repoId, author, message = "update", callback) =>
    @getHeadTree repoId, (err, tree, commitId) =>
      if err
        callback err
      else
        preparedEntries =  @_prepareEntries entries, repoId
        newEntries = preparedEntries.treeEntries
        tasks = preparedEntries.tasks
        date = new Date().getTime()
        mergedEntries = tree.entries
        newEntriesNames = (entry.name for entry in newEntries)
        mergedEntries = _.reject mergedEntries, (entry) -> _.include newEntriesNames, entry.name
        utils.mergeArrays mergedEntries, newEntries
        async.series tasks, (err, results) =>
          if err
            callback err
          else
            @_prepareTreeAndCommit mergedEntries, repoId, commitId, author, message, callback

  _prepareTreeAndCommit: (treeEntries, repoId, parentCommit, author, message, callback) =>
    date = new Date().getTime()
    root = new Tree(treeEntries, repoId)
    @treesDao.save root, (err, ok) =>
      if err
        callback err
      else
        @_prepareAndSaveCommit root, parentCommit, author, date, message, repoId, callback

  _prepareAndSaveCommit: (root, parentCommit, author, date, message, repoId, callback) =>
    @usersDao.get author, (err, user) =>
      if err
        callback err
      else
        commit = new Commit(root.id(), parentCommit, author, user.email, date, author, user.email, date, message, repoId)
        @commitsDao.save commit, (err, commit) =>
          if err
            callback err
          else
            @_updateRepoCommitRef repoId, commit.id(), (err, resp) ->
              if err
                callback err
              else
                callback undefined, commit.id()

  _updateRepoCommitRef: (repoId, commitId, callback) =>
    @getRepo repoId, (err, repo) =>
      if err
        callback err
      else
        repo.commit = commitId
        @reposDao.save repo, callback

  # Callback takes 3 parameters: err, entries and repo instance.
  fetchRepoRootEntriesById: (repoId, callback) =>
    @getHead repoId, (err, commitId, repo) =>
      if err
        callback err
      else
        @fetchRootEntriesForCommit commitId, (err, entries) ->
          if err
            callback err
          else
            callback undefined, entries, repo

  # Callback takes 3 parameters: err, commit id and repo instance.
  getHead: (repoId, callback) =>
   @getRepo repoId, (err, repo) ->
      if err
        callback err
      else
        callback undefined, repo.commit, repo

  # Callback accepts 3 parameters: error, tree and commit id.
  getHeadTree: (repoId, callback) =>
    @getHead repoId, (err, commitId) =>
      if err
        callback err
      else
        @getHeadTreeFromCommit commitId, callback

  # Callback accepts 3 parameters: error, tree and commit id.
  getHeadTreeFromCommit: (commitId, callback) =>
    @getCommit commitId, (err, commit) =>
      if err
        callback err
      else
        treeId = commit.tree
        @getTree treeId, (err, tree) ->
          if err
            callback err
          else
            callback undefined, tree,commitId

  fetchRootEntriesForCommit: (commitId, callback) =>
    @getHeadTreeFromCommit commitId,(err, tree) =>
      if err
        callback err
      else
        @getTreeEntries tree.id(), callback

  _prepareEntries: (entries, repoId) =>
    plainEntries = []
    tasks = []
    for entry in entries
      plainEntries.push entry.attributes()
      # todo (anton) trees can be added later
      if entry.entry.type == "blob"
        blob = entry.entry
        blob.repo = repoId
        # todo (anton) we can use dao.exists() before saving each blob.
        task = async.apply @blobsDao.save, blob
        tasks.push task
    {tasks: tasks, treeEntries: plainEntries}

  # @TODO write test
  getHistoryForRepo: (repoId, callback) =>
    @getHead repoId, (err, commitId) =>
      if err
        callback err
      else
        @getHistoryForCommit commitId, callback

  # @TODO write test
  getHistoryForCommit: (commitId, callback) =>  @commitsDao.getParents commitId, callback
  
  # @TODO write test
  getTreeEntries: (treeId, callback) =>
    @getBlobs treeId, (err, blobs) ->
      if err
        callback err
      else
        entries = tree.entries
        treeEntries = []
        for blob in blobs
          name = entry.name for entry in entries when entry.id == blob.id()
          treeEntries.push new TreeEntry name, blob
        callback err, treeEntries


  getBlobs: (id, callback) =>
    if !id
      callback {statusCode: 422, message: "Invalid parameters"}
    else
      @treesDao.getBlobs id, (err, blobs) ->
        if err
          err.message = "Cannot retrive blobs"
          callback err
        else
          callback undefined, blobs

  getRepo: (id, callback) =>
    if !id
      callback {statusCode: 422, message: "Invalid parameters"}
    else
      @reposDao.get id, (err, repo) ->
        if err
          err.statusCode = 400
          err.message = "Repo wasn't found"
          callback err
        else
          callback undefined, repo

  getBlob: (id, callback) =>
    if !id
      callback {statusCode: 422, message: "Invalid parameters"}
    else
      @blobsDao.get id, (err, blob) ->
        if err
          err.statusCode = 400
          err.message = "Blob wasn't found"
          callback err
        else
          callback undefined, blob

  getCommit: (id, callback) =>
    if !id
      callback {statusCode: 422, message: "Invalid parameters"}
    else
      @commitsDao.get id, (err, commit) ->
        if err
          err.statusCode = 400
          err.message = "Commit wasn't found"
        else
          callback undefined, commit

  getTree: (id, callback) =>
    if !id
      callback {statusCode: 422, message: "Invalid parameters"}
    else
      @treesDao.get id, (err, commit) ->
        if err
          err.statusCode = 400
          err.message = "Tree wasn't found"
        else
          callback undefined, commit

  # Factory method to deal with Git Objects
  # --------------
  # create new tree entry.
  createTreeEntry: (name, blob) -> new TreeEntry name, blob

  # Create new with provided data.
  createBlob: (data, repo, contentType = "application/json") -> new Blob(data, repo, null, contentType)

