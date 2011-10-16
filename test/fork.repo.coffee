assert     = require "assert"
async      = require "async"
_          = require "underscore"
Repo       = require("../lib/objects/repo").Repo
Blob       = require("../lib/objects/blob").Blob
TreeEntry  = require("../lib/objects/tree.entry").TreeEntry
reposDao   = require("../lib/dao/repos.dao").newInstance()
commitsDao = require("../lib/dao/commits.dao").newInstance()
blobsDao   = require("../lib/dao/blobs.dao").newInstance()
treesDao   = require("../lib/dao/trees.dao").newInstance()
usersDao   = require("../lib/dao/users.dao").newInstance()
MassiveGit = new (require("../lib/massive.git").MassiveGit)()

exports.testForkRepo = ->
  # create user
  step0 = (callback) ->
    MassiveGit.newUser "anton", "anton@circuithub.com", (err, user) ->
      assert.isUndefined err
      callback err, user
  # create repo
  step1 = (user, callback) ->
    MassiveGit.initRepo "project1", "anton", "project", (err, repo) ->
      assert.isUndefined err
      assert.equal "anton$project1", repo.id()
      callback err, repo
  step2 = (repo, callback) ->
    MassiveGit.forkRepo repo.id(), "new-project-name", "anton", (err, forkedRepo) ->
      console.log "forked repo", err, forkedRepo
      assert.isUndefined err
      assert.equal "anton$new-project-name", forkedRepo.id()
      assert.equal repo.id(), forkedRepo.forkedFrom
      assert.equal "new-project-name", forkedRepo.name
      assert.equal "anton", forkedRepo.author
      assert.equal  repo.public, forkedRepo.public
      assert.equal  repo.commit, forkedRepo.commit
  async.waterfall [step0, step1, step2], (err, results) ->
    # clear all temp data
    reposDao.deleteAll()


# todo (anton) create test for forking repo to another user

