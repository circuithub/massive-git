should   = require "should"
TestCase = require("./base/test.case").TestCase
usersDao = require("../lib/dao/users.dao").newInstance()
User     = require("../lib/objects/user").User


exports.testSaveUser = (beforeExit) ->
  # create new user and save it
  step1 = (callback) ->
    user = new User("anton", "anton@circuithub.com")
    user.id().should.equal "anton"
    usersDao.save user, (err, data) ->
      should.not.exist err
      should.exist data
      callback err, user
  # get user from db by id and compare with initial
  step2 = (user, callback) ->
    usersDao.get user.id(), (err, userFromDao) ->
      should.not.exist err
      userFromDao.equals(user).should.be.ok
      callback err
  testCase = new TestCase [step1, step2]
  testCase.tearDown = -> usersDao.deleteAll()
  testCase.run()
  beforeExit () -> testCase.tearDown()

