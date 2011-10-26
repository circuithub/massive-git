should     = require "should"
TestCase = require("./base/test.case").TestCase
commitsDao = require("../lib/dao/commits.dao").newInstance()
Commit     = require("../lib/objects/commit").Commit


exports.testSaveCommit = (beforeExit)->
  authoredDate = new Date().getTime()
  commitedDate = new Date().getTime()
  # create new commit and save it
  step1 = (callback) ->
    commit = new Commit("tree-id", "parent-id", "anton", authoredDate, "andrew", commitedDate, "initial commit", "anton$project1")
    commit.id().should.equal "4ca68e7f293e0b7445beda64f0f8fe854682a0ac"
    commitsDao.save commit, (err, data) ->
      should.not.exist err
      should.exist data
      callback err, commit
  # get commit from db by id and compare with initial
  step2 = (commit, callback) ->
    commitsDao.get commit.id(), (err, commitFromDao) ->
      should.not.exist err
      commitFromDao.equals(commit).should.be.ok
      callback err
  testCase = new TestCase [step1, step2]
  testCase.tearDown = ->  commitsDao.deleteAll()
  testCase.run()
  beforeExit () -> testCase.tearDown()

