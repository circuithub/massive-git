should     = require "should"
DbTestCase = require("./base/db.test.case").DbTestCase
MassiveGit = new (require("../lib/massive.git").MassiveGit)()
helper     = require "./helper/helper"

exports.testNewUserSuccess = ->
  username = "new-user-name" + Math.floor(1000 * Math.random())
  MassiveGit.newUser username, "hello@circuithub.com", (err, user) ->
    should.not.exist err
    should.exist user
    user.id().should.equal username
    user.should.have.property "email", "hello@circuithub.com"

exports.testInvalidEmail = ->
  username = "new-user-name" + Math.floor(1000 * Math.random())
  MassiveGit.newUser username, "circuithub.com", (err, user) ->
    should.exist err
    err.should.have.property "statusCode", 422
    err.should.have.property "message", "Email address is invalid"
    should.not.exist user

exports.testNullEmail = ->
  username = "new-user-name" + Math.floor(1000 * Math.random())
  MassiveGit.newUser username, null, (err, user) ->
    should.exist err
    err.should.have.property "statusCode", 422
    err.should.have.property "message", "Invalid parameters"
    should.not.exist user

exports.testUndefinedEmail = ->
  username = "new-user-name" + Math.floor(1000 * Math.random())
  MassiveGit.newUser username, undefined, (err, user) ->
    should.exist err
    err.should.have.property "statusCode", 422
    err.should.have.property "message", "Invalid parameters"
    should.not.exist user

exports.testNullUsername = ->
  MassiveGit.newUser null, "hello@circuithub.com", (err, user) ->
    should.exist err
    err.should.have.property "statusCode", 422
    err.should.have.property "message", "Invalid parameters"
    should.not.exist user

exports.testUndefinedUsername = ->
  MassiveGit.newUser undefined, "hello@circuithub.com", (err, user) ->
    should.exist err
    err.should.have.property "statusCode", 422
    err.should.have.property "message", "Invalid parameters"
    should.not.exist user

exports.testShortUsername = ->
  randomName = "a" + Math.floor(10 * Math.random())
  MassiveGit.newUser randomName, "hello@circuithub.com", (err, user) ->
    should.exist err
    err.should.have.property "statusCode", 422
    err.should.have.property "message", "Userame is out of range"
    should.not.exist user

exports.testLongUsername = ->
  randomName = "aaaaaaaaaaaaaaaaaaaaa" + Math.floor(1000000000 * Math.random())
  MassiveGit.newUser randomName, "hello@circuithub.com", (err, user) ->
    should.exist err
    err.should.have.property "statusCode", 422
    err.should.have.property "message", "Userame is out of range"
    should.not.exist user

exports.testEmptyUsername = ->
  MassiveGit.newUser "     ", "hello@circuithub.com", (err, user) ->
    should.exist err
    err.should.have.property "statusCode", 422
    err.should.have.property "message", "Invalid parameters"
    should.not.exist user

