Repo       = require("./objects/repo").Repo
Tree       = require("./objects/tree").Tree
Commit     = require("./objects/commit").Commit
reposDao   = require("./dao/repos.dao").newInstance()
commitsDao = require("./dao/commits.dao").newInstance()
treesDao   = require("./dao/trees.dao").newInstance()
blobsDao   = require("./dao/blobs.dao").newInstance()

class MassiveGit

  newRepo: (name, author, type, callback) ->
    repo = new Repo(name, author, type)
    repository.save repo, callback


  commit: (entries)

    root = new Tree(entries, repo.id())
    date = new Date().getTime()
    commit = new Commit(root.id(), null, author, date, author, date, "initial commit", repo.id())
    repo.commit = commit.id()


  fetchRepo: (repo, callback) =>
    commitId = repo.commit
    commitsDao.get commitId, (err, commit) ->
      treeId = commit.tree
      treesDao.get treeId, (err, tree) ->
        console.log "tree entries", tree.entries

  fetchRepoById: (id, callback) =>

  addToIndex: =>

  commits: (repo)=>

