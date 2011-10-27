should     = require "should"
DbTestCase = require("./base/db.test.case").DbTestCase
MassiveGit = new (require("../lib/massive.git").MassiveGit)()
helper     = require "./helper/helper"

exports.testForkRepoWithSameUser = (beforeExit) ->
  randomPartName = "part" + Math.floor(1000 * Math.random())
  randomForkedPartName = "forked-part" + Math.floor(1000 * Math.random())
  username = "random-user" + Math.floor(1000 * Math.random())
  forkedRepoId = username + "$" + randomForkedPartName
  # create user with repo
  step1 = (callback) ->
    helper.createUserWithRepo username, randomPartName, "part", callback
  # fork repo
  step2 = (repo, callback) ->
    MassiveGit.forkRepo repo.id(), randomForkedPartName, username, (err, forkedRepo) ->
      should.not.exist err
      forkedRepo.forkedFrom.should.equal repo.id()
      forkedRepo.id().should.equal forkedRepoId
      forkedRepo.should.have.property "name", randomForkedPartName
      forkedRepo.should.have.property "author", username
      forkedRepo.public.should.be.ok
      should.not.exist forkedRepo.commit
  testCase = new DbTestCase [step1, step2]
  testCase.run()
  beforeExit () -> testCase.tearDown()

exports.testForkRepoWithAnotherUser = (beforeExit)->
  randomPartName = "part" + Math.floor(1000 * Math.random())
  randomForkedPartName = "forked-part" + Math.floor(1000 * Math.random())
  forkerUsername = "another-user" + Math.floor(1000 * Math.random())
  username = "random-user" + Math.floor(1000 * Math.random())
  forkedRepoId = forkerUsername + "$" + randomForkedPartName
  # create user
  step1 = (callback) ->
    helper.createUser forkerUsername, callback
  # create another user with repo
  step2 = (results, callback) ->
    helper.createUserWithRepo username, randomPartName, "part", callback
  # fork repo
  step3 = (repo, callback) ->
    MassiveGit.forkRepo repo.id(), randomForkedPartName, forkerUsername, (err, forkedRepo) ->
      should.not.exist err
      forkedRepo.forkedFrom.should.equal repo.id()
      forkedRepo.id().should.equal forkedRepoId
      forkedRepo.should.have.property "name", randomForkedPartName
      forkedRepo.should.have.property "author", forkerUsername
      forkedRepo.public.should.be.ok
      should.not.exist forkedRepo.commit

  testCase = new DbTestCase [step1, step2, step3]
  testCase.run()
  beforeExit () -> testCase.tearDown()

