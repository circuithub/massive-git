async      = require "async"
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

  initRepo: (name, author, type, callback) ->
    repo = new Repo(name, author, type)
    reposDao.save repo, (err, ok) ->
      callback err, ok
      #usersDao
      # todo (anton) add link from new repo to user.

  deleteRepo: (repoId, callback) ->
  # todo(anton) remove link from new repo to user.
    reposDao.delete repoId, callback



  repos: (user, type, callback) ->
    reposDao.findAll user, type, callback

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

  fetchRepoRootEntries: (repo, callback) =>
    commitId = repo.commit

  fetchRepoRootEntriesById: (id, callback) =>

  fetchRootEntriesForCommit: (commitId, callback) =>
    commitsDao.get commitId, (err, commit) ->
      treeId = commit.tree
      fetchTree = (callback) ->
        treesDao.get treeId, (err, tree) ->
          console.log "tree entries", tree.entries
          callback err, tree
      fetchTreeBlobs = (tree, callback) ->
        treesDao.getBlobs tree.id(), (err, blobs) ->
          console.log "tree blobs", blobsDao
          callback err, tree, blobs
      async.series [fetchTree, fetchTreeBlobs], (err, results) ->
        if(err)
          callback err
        else
          console.log "results>>>" results
          entries = results[0].entries
          blobs   = results[1]
          #blobsMap = ( for blob in blobs)
          #for entry in entries



  addToIndex: =>

  commits: (repo)=>

