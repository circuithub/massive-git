should   = require "should"
TestCase = require("./base/test.case").TestCase
reposDao = require("../lib/dao/repos.dao").newInstance()
Repo     = require("../lib/objects/repo").Repo

exports.testSaveRepo = ->
  # create new repo and save it
  step1 = (callback) ->
    repo = new Repo("project1", "anton", "project")
    reposDao.save repo, (err, data) ->
      should.not.exist err
      should.exist data
      callback err, repo
  # get repo from db by id and compare with initial
  step2 = (repo, callback) ->
    reposDao.get repo.id(), (err, repoFromDao) ->
      should.not.exist err
      repoFromDao.equals(repo).should.be.ok
      callback err
  testCase = new TestCase [step1, step2]
  testCase.tearDown = -> reposDao.deleteAll()
  testCase.run()

