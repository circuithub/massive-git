async      = require "async"
User       = require("./objects/user").User
Repo       = require("./objects/repo").Repo
Tree       = require("./objects/tree").Tree
TreeEntry  = require("./objects/tree.entry").TreeEntry
Commit     = require("./objects/commit").Commit
reposDao   = require("./dao/repos.dao").newInstance()
usersDao   = require("./dao/users.dao").newInstance()
commitsDao = require("./dao/commits.dao").newInstance()
treesDao   = require("./dao/trees.dao").newInstance()
blobsDao   = require("./dao/blobs.dao").newInstance()

MassiveGit = exports.MassiveGit = class MassiveGit

  newUser: (username, email, callback) ->
    user = new User username, email
    usersDao.save user, callback

  initRepo: (name, author, type, callback) ->
    repo = new Repo(name, author, type)
    reposDao.save repo, (err, ok) ->
      if(err)
        callback err
      else
        usersDao.addRepo author, repo.id(), type, (err, ok) ->
          if(err)
            callback err
          else
            callback undefined, repo

  deleteRepo: (repoId, callback) ->
    reposDao.delete repoId, (err, ok) ->
      if(err)
        callback err
      else
        # todo(anton) remove link from new repo to user.
        callback undefined


  repos: (user, type, callback) ->
    usersDao.findAllRepos user, type, callback

  commit: (entries, repoId, author, message = "initial commit", parentCommit = undefined, callback) =>
    plainEntries = []
    date = new Date().getTime()
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
    root = new Tree(plainEntries, repoId)
    tasks.push async.apply treesDao.save, root
    commit = new Commit(root.id(), parentCommit, author, date, author, date, message, repoId)
    tasks.push async.apply commitsDao.save, commit
    tasks.push async.apply @_updateRepoCommitRef, repoId, commit.id()
    # todo (anton) for some reason when we use parallel my riak server can be stopped. Investigate this.
    async.series tasks, (err, results) ->
      callback err, commit.id()

  _updateRepoCommitRef: (repoId, commitId, callback) =>
    reposDao.get repoId, (err, repo) ->
      if(err)
        callback err
      else
        repo.commit = commitId
        reposDao.save repo, callback

  head: (repoId, callback) =>
    reposDao.get repoId, (err, repo) ->
      if(err)
        callback err
      else
        callback undefined, repo.commit

  fetchRepoRootEntriesById: (repoId, callback) =>
    @head repoId, (err, commitId) =>
      if(err)
        callback err
      else
        @fetchRootEntriesForCommit commitId, callback

  fetchRootEntriesForCommit: (commitId, callback) =>
    commitsDao.get commitId, (err, commit) ->
      treeId = commit.tree
      fetchTree = (stepCallback) ->
        treesDao.get treeId, (err, tree) ->
          stepCallback err, tree
      fetchTreeBlobs = (tree, stepCallback) ->
        treesDao.getBlobs tree.id(), (err, blobs) ->
          entries = tree.entries
          treeEntries = []
          for blob in blobs
            blobId = blob.id()
            name = entry.name for entry in entries when entry.id == blobId
            treeEntries.push new TreeEntry name, blob
          stepCallback err, treeEntries
      async.waterfall [fetchTree, fetchTreeBlobs], callback


  addToIndex: =>

  commits: (repo)=>

