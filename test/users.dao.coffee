should   = require "should"
async    = require "async"
usersDao = require("../lib/dao/users.dao").newInstance()
User     = require("../lib/objects/user").User


exports.testSaveUser = ->
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
      userFromDao.id().should.equal user.id()
      userFromDao.email.should.equal user.email
      should.deepEqual user.links(), userFromDao.links()
      should.deepEqual user.attributes(), userFromDao.attributes()
      callback err
  async.waterfall [step1, step2], (err, results) ->
    # clear all temp data
    usersDao.deleteAll()

