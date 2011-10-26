should     = require "should"
DbTestCase = require("./base/db.test.case").DbTestCase
MassiveGit = new (require("../lib/massive.git").MassiveGit)()
helper     = require "./fixture/helper"

exports.testForkRepoWithSameUser = (beforeExit) ->
  randomPartName = "part" + Math.floor(1000 * Math.random())
  randomForkedPartName = "forked-part" + Math.floor(1000 * Math.random())
  # create user with repo
  step1 = (callback) ->
    helper.createUserWithRepo "anton", randomPartName, "part", callback
  # fork repo
  step2 = (repo, callback) ->
    MassiveGit.forkRepo repo.id(), randomForkedPartName, "anton", (err, forkedRepo) ->
      should.not.exist err
      forkedRepo.forkedFrom.should.equal repo.id()
      forkedRepo.id().should.equal "anton$" + randomForkedPartName
      forkedRepo.should.have.property "name", randomForkedPartName
      forkedRepo.should.have.property "author", "anton"
      forkedRepo.public.should.be.ok
      should.not.exist forkedRepo.commit
  testCase = new DbTestCase [step1, step2]
  testCase.run()
  beforeExit () -> testCase.tearDown()

exports.testForkRepoWithAnotherUser = (beforeExit)->
  randomPartName = "part" + Math.floor(1000 * Math.random())
  randomForkedPartName = "forked-part" + Math.floor(1000 * Math.random())
  # create user
  step1 = (callback) ->
    helper.createUser "andrew", callback
  # create another user with repo
  step2 = (results, callback) ->
    helper.createUserWithRepo "anton", randomPartName, "part", callback
  # fork repo
  step3 = (repo, callback) ->
    MassiveGit.forkRepo repo.id(), randomForkedPartName, "andrew", (err, forkedRepo) ->
      should.not.exist err
      forkedRepo.forkedFrom.should.equal repo.id()
      forkedRepo.id().should.equal "andrew$" + randomForkedPartName
      forkedRepo.should.have.property "name", randomForkedPartName
      forkedRepo.should.have.property "author", "andrew"
      forkedRepo.public.should.be.ok
      should.not.exist forkedRepo.commit

  testCase = new DbTestCase [step1, step2, step3]
  testCase.run()
  beforeExit () -> testCase.tearDown()

