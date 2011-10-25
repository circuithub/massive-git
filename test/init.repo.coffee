should     = require "should"
DbTestCase = require("./base/db.test.case").DbTestCase
MassiveGit = new (require("../lib/massive.git").MassiveGit)()
helper     = require "./fixture/helper"

exports.testInitRepoForFakeUser = ->
  MassiveGit.initRepo "new-project-name", "fake-user-name", "project", (err, repo) ->
    should.exist err
    err.should.have.property "message", "Repo already exists"
    err.should.have.property "statusCode", 422
    should.not.exist repo

exports.testUndefinedRepoName = ->
  MassiveGit.initRepo undefined, "fake-user-name", "project", (err, repo) ->
    should.exist err
    err.should.have.property "message", "Invalid parameters"
    err.should.have.property "statusCode", 422
    should.not.exist repo

exports.testNullRepoName = ->
  MassiveGit.initRepo null, "fake-user-name", "project", (err, repo) ->
    should.exist err
    err.should.have.property "message", "Invalid parameters"
    err.should.have.property "statusCode", 422
    should.not.exist repo

exports.testUndefinedUserName = ->
  MassiveGit.initRepo "repo1", undefined, "project", (err, repo) ->
    should.exist err
    err.should.have.property "message", "Invalid parameters"
    err.should.have.property "statusCode", 422
    should.not.exist repo

exports.testNullUserName = ->
  MassiveGit.initRepo "repo1", null, "project", (err, repo) ->
    should.exist err
    err.should.have.property "message", "Invalid parameters"
    err.should.have.property "statusCode", 422
    should.not.exist repo

exports.testSaveRepoWithExistentName = ->
  # todo (anton) implement this test

