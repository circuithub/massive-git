assert   = require "assert"
async    = require "async"
usersDao = require("../lib/dao/users.dao").newInstance()
User     = require("../lib/objects/user").User


exports.testSaveUser = ->
  # create new user and save it
  step1 = (callback) ->
    user = new User("anton", "anton@circuithub.com", "encoded_password", new Date().getTime())
    assert.equal "anton", user.id()
    usersDao.save user, (err, data) ->
      assert.isUndefined err
      callback err, user
  # get user from db by id and compare with initial
  step2 = (user, callback) ->
    usersDao.get user.id(), (err, userFromDao) ->
      assert.isUndefined err
      assert.equal user.id(), userFromDao.id()
      assert.equal user.email, userFromDao.email
      assert.equal user.password, userFromDao.password
      assert.equal user.date, userFromDao.date
      assert.deepEqual user.links(), userFromDao.links()
      assert.deepEqual user.attributes(), userFromDao.attributes()
      callback err
  async.waterfall [step1, step2], (err, results) ->
    # clear all temp data
    usersDao.deleteAll()

