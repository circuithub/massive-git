assert   = require "assert"
async    = require "async"
reposDao = require("../lib/dao/repos.dao").newInstance()
Repo     = require("../lib/objects/repo").Repo


exports.testSaveRepo = ->
  # create new repo and save it
  step1 = (callback) ->
    repo = new Repo("circuithub.com/anton/project1", "anton", "project")
    assert.equal "circuithub.com-anton-project1", repo.id()
    reposDao.save repo, (err, data) ->
      assert.isUndefined err
      callback err, repo
  # get repo from db by id and compare with initial
  step2 = (repo, callback) ->
    reposDao.get repo.id(), (err, repoFromDao) ->
      assert.isUndefined err
      console.log err, repoFromDao
      callback err
  async.waterfall [step1, step2], (err, results) ->
    # clear all temp data
    reposDao.deleteAll()

