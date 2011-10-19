async        = require "async"
_            = require "underscore"
utils        = require("./objects/utils")
User         = require("./objects/user").User
Repo         = require("./objects/repo").Repo
Tree         = require("./objects/tree").Tree
TreeEntry    = require("./objects/tree.entry").TreeEntry
Commit       = require("./objects/commit").Commit
reposDao     = require("./dao/repos.dao").newInstance()
usersDao     = require("./dao/users.dao").newInstance()
commitsDao   = require("./dao/commits.dao").newInstance()
treesDao     = require("./dao/trees.dao").newInstance()
blobsDao     = require("./dao/blobs.dao").newInstance()

MassiveGit = exports.MassiveGit = class MassiveGit

  newUser: (username, email, callback) =>
    user = new User username, email
    usersDao.save user, callback

  initRepo: (name, author, type, callback) =>
    repo = new Repo(name, author, type)
    @_saveRepo repo, callback

  forkRepo: (repoId, name, author, callback) =>
    reposDao.get repoId, (err, repo) =>
      if(err)
        callback err
      else
        forkedRepo = repo.fork name, author
        @_saveRepo forkedRepo, callback

  _saveRepo: (repo, callback) =>
    reposDao.save repo, (err, ok) ->
      if(err)
        callback err
      else
        usersDao.addRepo repo.author, repo.id(), repo.type, (err, ok) ->
          if(err)
            callback err
          else
            callback undefined, repo


  deleteRepo: (repoId, author, type, callback) =>
    reposDao.delete repoId, (err, ok) ->
      if(err)
        callback err
      else
        usersDao.removeRepo author, repoId, type, (err, ok) ->
          if(err)
            callback err
          else
            callback undefined, ok

  repos: (user, type, callback) =>
    usersDao.findAllRepos user, type, callback

  reposEntries: (user, type, callback) =>
    usersDao.fetchAllRepos user, type, callback


  commit: (entries, repoId, author, message = "initial commit", parentCommit = undefined, callback) =>
    preparedEntries = @_prepareEntries entries, repoId
    tasks = preparedEntries.tasks
    treeEntries = preparedEntries.treeEntries
    @_prepareTreeAndCommit treeEntries, repoId, parentCommit, author, message, tasks, callback

  addToIndex: (entries, repoId, author, message = "update", callback) =>
    @headTree repoId, (err, tree, commitId) =>
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
    tasks.push async.apply treesDao.save, root
    tasks.push async.apply commitsDao.save, commit
    tasks.push async.apply @_updateRepoCommitRef, repoId, commit.id()
    # todo (anton) for some reason when we use parallel my riak server can crash. Investigate this.
    async.series tasks, (err, results) ->
      callback err, commit.id()


  _updateRepoCommitRef: (repoId, commitId, callback) =>
    reposDao.get repoId, (err, repo) ->
      if(err)
        callback err
      else
        repo.commit = commitId
        reposDao.save repo, callback

  fetchRepoRootEntriesById: (repoId, callback) =>
    @head repoId, (err, commitId) =>
      if(err)
        callback err
      else
        @fetchRootEntriesForCommit commitId, callback

  head: (repoId, callback) =>
    reposDao.get repoId, (err, repo) ->
      if(err)
        callback err
      else
        callback undefined, repo.commit

  # Callback accepts 3 parameters: error, tree and commit id.
  headTree: (repoId, callback) =>
    @head repoId, (err, commitId) =>
      if(err)
        callback err
      else
        @headTreeFromCommit commitId, callback

  # Callback accepts 3 parameters: error, tree and commit id.
  headTreeFromCommit: (commitId, callback) =>
    commitsDao.get commitId, (err, commit) ->
      treeId = commit.tree
      treesDao.get treeId, (err, tree) ->
        if(err)
          callback err
        else
          callback undefined, tree,commitId

  fetchRootEntriesForCommit: (commitId, callback) =>
    @headTreeFromCommit commitId,(err, tree) ->
      if(err)
        callback err
      else
        treesDao.getBlobs tree.id(), (err, blobs) ->
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
        task = async.apply blobsDao.save, blob
        tasks.push task
    {tasks: tasks, treeEntries: plainEntries}

  commits: (repo)=>

  blob: (id, callback) => blobsDao.get id, callback

