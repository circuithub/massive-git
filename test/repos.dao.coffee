assert   = require "assert"
async    = require "async"
reposDao = require("../lib/dao/repos.dao").newInstance()
Repo     = require("../lib/objects/repo").Repo


exports.testSaveRepo = ->
  # create new repo and save it
  step1 = (callback) ->
    repo = new Repo("project1", "anton", "project")
    assert.equal "anton$project1", repo.id()
    reposDao.save repo, (err, data) ->
      assert.isUndefined err
      callback err, repo
  # get repo from db by id and compare with initial
  step2 = (repo, callback) ->
    reposDao.get repo.id(), (err, repoFromDao) ->
      assert.isUndefined err
      assert.equal repo.id(), repoFromDao.id()
      assert.equal repo.owner, repoFromDao.owner
      assert.equal repo.public, repoFromDao.public
      assert.equal repo.forkedFrom, repoFromDao.forkedFrom
      assert.deepEqual repo.links(), repoFromDao.links()
      assert.deepEqual repo.attributes(), repoFromDao.attributes()
      callback err
  async.waterfall [step1, step2], (err, results) ->
    # clear all temp data
    reposDao.deleteAll()

