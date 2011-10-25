should     = require "should"
MassiveGit = new (require("../lib/massive.git").MassiveGit)()

exports.testGetFakeRepo = ->
  MassiveGit.getRepo "fake-repo-id", (err, repo) ->
    err.should.exist
    err.should.have.property "message", "Repo wasn't found"
    err.should.have.property "statusCode", 400
    should.not.exist repo

exports.testGetFakeBlob = ->
  MassiveGit.getBlob "fake-blob-id", (err, blob) ->
    err.should.exist
    err.should.have.property "message", "Blob wasn't found"
    err.should.have.property "statusCode", 400
    should.not.exist blob

exports.testGetFakeCommit = ->
  MassiveGit.getCommit "fake-commit-id", (err, commit) ->
    err.should.exist
    err.should.have.property "message", "Commit wasn't found"
    err.should.have.property "statusCode", 400
    should.not.exist commit

exports.testGetFakeTree = ->
  MassiveGit.getTree "fake-tree-id", (err, tree) ->
    err.should.exist
    err.should.have.property "message", "Tree wasn't found"
    err.should.have.property "statusCode", 400
    should.not.exist tree

exports.testGetRepoByNullId = ->
  MassiveGit.getRepo null, (err, repo) ->
    err.should.exist
    err.should.have.property "message", "Invalid parameters"
    err.should.have.property "statusCode", 422
    should.not.exist repo

exports.testGetRepoByUndefinedId = ->
  MassiveGit.getRepo null, (err, repo) ->
    err.should.exist
    err.should.have.property "message", "Invalid parameters"
    err.should.have.property "statusCode", 422
    should.not.exist repo

exports.testGetBlobByNullId = ->
  MassiveGit.getBlob null, (err, blob) ->
    err.should.exist
    err.should.have.property "message", "Invalid parameters"
    err.should.have.property "statusCode", 422
    should.not.exist blob

exports.testGetBlobByUndefinedId = ->
  MassiveGit.getBlob null, (err, blob) ->
    err.should.exist
    err.should.have.property "message", "Invalid parameters"
    err.should.have.property "statusCode", 422
    should.not.exist blob

exports.testGetCommitByNullId = ->
  MassiveGit.getCommit null, (err, commit) ->
    err.should.exist
    err.should.have.property "message", "Invalid parameters"
    err.should.have.property "statusCode", 422
    should.not.exist commit

exports.testGetCommitByUndefinedId = ->
  MassiveGit.getCommit null, (err, commit) ->
    err.should.exist
    err.should.have.property "message", "Invalid parameters"
    err.should.have.property "statusCode", 422
    should.not.exist commit

exports.testGetTreeByNullId = ->
  MassiveGit.getTree null, (err, tree) ->
    err.should.exist
    err.should.have.property "message", "Invalid parameters"
    err.should.have.property "statusCode", 422
    should.not.exist tree

exports.testGetTreeByUndefinedId = ->
  MassiveGit.getTree null, (err, tree) ->
    err.should.exist
    err.should.have.property "message", "Invalid parameters"
    err.should.have.property "statusCode", 422
    should.not.exist tree

