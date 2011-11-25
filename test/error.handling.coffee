should     = require "should"
MassiveGit = new (require("../lib/massive.git").MassiveGit)()

describe "fake", ->
  describe "repo", ->
    it "should not exists", ->
      MassiveGit.getRepo "fake-repo-id", (err, repo) ->
        err.should.exist
        err.should.have.property "message", "Repo wasn't found"
        err.should.have.property "statusCode", 400
        should.not.exist repo
  describe "blob", ->
    it "should not exists", ->
      MassiveGit.getBlob "fake-blob-id", (err, repo) ->
        err.should.exist
        err.should.have.property "message", "Blob wasn't found"
        err.should.have.property "statusCode", 400
        should.not.exist repo
  describe "commit", ->
    it "should not exists", ->
      MassiveGit.getCommit "fake-commit-id", (err, repo) ->
        err.should.exist
        err.should.have.property "message", "Commit wasn't found"
        err.should.have.property "statusCode", 400
        should.not.exist repo
  describe "tree", ->
    it "should not exists", ->
      MassiveGit.getTree "fake-tree-id", (err, repo) ->
        err.should.exist
        err.should.have.property "message", "Tree wasn't found"
        err.should.have.property "statusCode", 400
        should.not.exist repo   


describe "when id is null", ->
  describe "for repo", ->
    it "should return 'Invalid parameters' error", ->
      MassiveGit.getRepo null, (err, repo) ->
        err.should.exist
        err.should.have.property "message", "Invalid parameters"
        err.should.have.property "statusCode", 422
        should.not.exist repo
  describe "for blob", ->
    it "should return 'Invalid parameters' error", ->
      MassiveGit.getBlob null, (err, repo) ->
        err.should.exist
        err.should.have.property "message", "Invalid parameters"
        err.should.have.property "statusCode", 422
        should.not.exist repo
  describe "for commit", ->
    it "should return 'Invalid parameters' error", ->
      MassiveGit.getCommit null, (err, repo) ->
        err.should.exist
        err.should.have.property "message", "Invalid parameters"
        err.should.have.property "statusCode", 422
        should.not.exist repo
  describe "for tree", ->
    it "should return 'Invalid parameters' error", ->
      MassiveGit.getTree null, (err, repo) ->
        err.should.exist
        err.should.have.property "message", "Invalid parameters"
        err.should.have.property "statusCode", 422
        should.not.exist repo

describe "when id is undefined", ->
  describe "for repo", ->
    it "should return 'Invalid parameters' error", ->
      MassiveGit.getRepo undefined, (err, repo) ->
        err.should.exist
        err.should.have.property "message", "Invalid parameters"
        err.should.have.property "statusCode", 422
        should.not.exist repo
  describe "for blob", ->
    it "should return 'Invalid parameters' error", ->
      MassiveGit.getBlob undefined, (err, repo) ->
        err.should.exist
        err.should.have.property "message", "Invalid parameters"
        err.should.have.property "statusCode", 422
        should.not.exist repo
  describe "for commit", ->
    it "should return 'Invalid parameters' error", ->
      MassiveGit.getCommit undefined, (err, repo) ->
        err.should.exist
        err.should.have.property "message", "Invalid parameters"
        err.should.have.property "statusCode", 422
        should.not.exist repo
  describe "for tree", ->
    it "should return 'Invalid parameters' error", ->
      MassiveGit.getTree undefined, (err, repo) ->
        err.should.exist
        err.should.have.property "message", "Invalid parameters"
        err.should.have.property "statusCode", 422
        should.not.exist repo



