should     = require "should"
DbTestCase = require("./base/db.test.case").DbTestCase
MassiveGit = new (require("../lib/massive.git").MassiveGit)()
helper     = require "./helper/helper"

describe "new user", ->
  describe "with correct parameters", ->
    username = "new-user-name" + Math.floor(100000 * Math.random())
    it "should return user object with properties", (done) ->  
      MassiveGit.newUser username, "hello@circuithub.com", (err, user) -> 
        should.not.exist err
        should.exist user
        user.id().should.equal username
        user.should.have.property "email", "hello@circuithub.com"
        done err
  describe "with invalid email", ->
    username = "new-user-name" + Math.floor(1000 * Math.random())
    it "should return error 'Email address is invalid'", (done) ->
      MassiveGit.newUser username, "circuithub.com", (err, user) ->
        should.exist err
        err.should.have.property "statusCode", 422
        err.should.have.property "message", "Email address is invalid"
        should.not.exist user
        done()
  describe "with null email", ->
    username = "new-user-name" + Math.floor(1000 * Math.random())
    it "should return error 'Invalid parameters'", (done) ->
      MassiveGit.newUser username, null, (err, user) ->
        should.exist err
        err.should.have.property "statusCode", 422
        err.should.have.property "message", "Invalid parameters"
        done()
  describe "with undefined email", ->
    username = "new-user-name" + Math.floor(1000 * Math.random())
    it "should return error 'Invalid parameters'", (done) ->
      MassiveGit.newUser username, undefined, (err, user) ->
        should.exist err
        err.should.have.property "statusCode", 422
        err.should.have.property "message", "Invalid parameters"
        should.not.exist user
        done()
  describe "with null username", ->
    it "should return error 'Invalid parameters'", (done) ->
      MassiveGit.newUser null, "anton@circuithub.com", (err, user) ->
        should.exist err
        err.should.have.property "statusCode", 422
        err.should.have.property "message", "Invalid parameters"
        should.not.exist user
        done()
  describe "with undefined username", ->
    it "should return error 'Invalid parameters'", (done) ->
      MassiveGit.newUser undefined, "hello@circuithub.com", (err, user) ->
        should.exist err
        err.should.have.property "statusCode", 422
        err.should.have.property "message", "Invalid parameters"
        should.not.exist user
        done()
  describe "with empty username", ->
    it "should return error 'Invalid parameters'", (done) ->
      MassiveGit.newUser "", "hello@circuithub.com", (err, user) ->
        should.exist err
        err.should.have.property "statusCode", 422
        err.should.have.property "message", "Invalid parameters"
        should.not.exist user
        done()
  describe "with blank username", ->
    it "should return error 'Invalid parameters'", (done) ->
      MassiveGit.newUser "      ", "hello@circuithub.com", (err, user) ->
        should.exist err
        err.should.have.property "statusCode", 422
        err.should.have.property "message", "Invalid parameters"
        should.not.exist user
        done()
  describe "with short username", ->
    randomName = "" + Math.floor(100 * Math.random())
    it "should return error 'Username is out of range'", (done) ->
      MassiveGit.newUser randomName, "hello@circuithub.com", (err, user) ->
        should.exist err
        err.should.have.property "statusCode", 422
        err.should.have.property "message", "Username is out of range"
        should.not.exist user
        done()
  describe "with long username", ->
    randomName = "aaaaaaaaaaaaaaaaaaaaa" + Math.floor(1000000000 * Math.random())
    it "should return error 'Username is out of range'", (done) ->
      MassiveGit.newUser randomName, "hello@circuithub.com", (err, user) ->
        should.exist err
        err.should.have.property "statusCode", 422
        err.should.have.property "message", "Username is out of range"
        should.not.exist user
        done()


