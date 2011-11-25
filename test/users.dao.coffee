should   = require "should"
usersDao = require("../lib/dao/users.dao").newInstance()
User     = require("../lib/objects/user").User

describe "save user", ->
  user = new User("anton", "anton@circuithub.com")
  before (done) ->
    usersDao.save user, (err, data) ->
      should.not.exist err
      should.exist data
      done err
  it "should be equal to retrieved user", (done) ->    
    usersDao.get user.id(), (err, userFromDao) ->
      should.not.exist err
      userFromDao.equals(user).should.be.ok
      done err
  after (done) ->
    usersDao.remove user.id(), done


