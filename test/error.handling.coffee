should     = require "should"
MassiveGit = new (require("../lib/massive.git").MassiveGit)()

describe "MassiveGit", ->
  describe "#getRepo('fake-repo-id')", ->
    it "return 'Repo wasn't found' error", (done) ->
      MassiveGit.getRepo "fake-repo-id", (err, repo) ->
        err.should.exist
        err.should.have.property "message", "Repo wasn't found"
        err.should.have.property "statusCode", 400
        should.not.exist repo
        done()
  describe "#getBlob('fake-blob-id')", ->
    it "return 'Blob wasn't found' error", (done) ->
      MassiveGit.getBlob "fake-blob-id", (err, blob) ->
        err.should.exist
        err.should.have.property "message", "Blob wasn't found"
        err.should.have.property "statusCode", 400
        should.not.exist blob
        done()
  describe "#getCommit('fake-commit-id')", ->
    it "return 'Commit wasn't found' error", (done) ->
      MassiveGit.getCommit "fake-commit-id", (err, commit) ->
        err.should.exist
        err.should.have.property "message", "Commit wasn't found"
        err.should.have.property "statusCode", 400
        should.not.exist commit
        done()
  describe "#getTree('fake-tree-id')", ->
    it "return 'Tree wasn't found' error", (done) ->
      MassiveGit.getTree "fake-tree-id", (err, tree) ->
        err.should.exist
        err.should.have.property "message", "Tree wasn't found"
        err.should.have.property "statusCode", 400
        should.not.exist tree
        done()
  describe "#getBlobs('fake-tree-id')", ->
    it "return 'Cannot retrive blobs' error", (done) ->
      MassiveGit.getBlobs "fake-tree-id", (err, blobs) ->
        blobs.length.should.equal 0
        done err
  describe "#getRepo(null)", ->
    it "return 'Invalid parameters' error", (done) ->
      MassiveGit.getRepo null, (err, repo) ->
        err.should.exist
        err.should.have.property "message", "Invalid parameters"
        err.should.have.property "statusCode", 422
        should.not.exist repo
        done()
  describe "#getBlob(null)", ->
    it "return 'Invalid parameters' error", (done) ->
      MassiveGit.getBlob null, (err, blob) ->
        err.should.exist
        err.should.have.property "message", "Invalid parameters"
        err.should.have.property "statusCode", 422
        should.not.exist blob
        done()
  describe "#getCommit(null)", ->
    it "return 'Invalid parameters' error", ->
      MassiveGit.getCommit null, (err, commit) ->
        err.should.exist
        err.should.have.property "message", "Invalid parameters"
        err.should.have.property "statusCode", 422
        should.not.exist commit
  describe "#getTree(null)", ->
    it "return 'Invalid parameters' error", (done) ->
      MassiveGit.getTree null, (err, tree) ->
        err.should.exist
        err.should.have.property "message", "Invalid parameters"
        err.should.have.property "statusCode", 422
        should.not.exist tree
        done()
  describe "#getBlobs(null)", ->
    it "return 'Invalid parameters' error", (done) ->
      MassiveGit.getBlobs null, (err, blobs) ->
        err.should.exist
        err.should.have.property "message", "Invalid parameters"
        err.should.have.property "statusCode", 422
        should.not.exist blobs
        done()
  describe "#getRepo(undefined)", ->
    it "return 'Invalid parameters' error", (done) ->
      MassiveGit.getRepo undefined, (err, repo) ->
        err.should.exist
        err.should.have.property "message", "Invalid parameters"
        err.should.have.property "statusCode", 422
        should.not.exist repo
        done()
  describe "#getBlob(undefined)", ->
    it "return 'Invalid parameters' error", (done) ->
      MassiveGit.getBlob undefined, (err, blob) ->
        err.should.exist
        err.should.have.property "message", "Invalid parameters"
        err.should.have.property "statusCode", 422
        should.not.exist blob
        done()
  describe "#getCommit(undefined)", ->
    it "return 'Invalid parameters' error", (done) ->
      MassiveGit.getCommit undefined, (err, commit) ->
        err.should.exist
        err.should.have.property "message", "Invalid parameters"
        err.should.have.property "statusCode", 422
        should.not.exist commit
        done()
  describe "#getTree(undefined)", ->
    it "return 'Invalid parameters' error", (done) ->
      MassiveGit.getTree undefined, (err, tree) ->
        err.should.exist
        err.should.have.property "message", "Invalid parameters"
        err.should.have.property "statusCode", 422
        should.not.exist tree
        done()
  describe "#getBlobs(undefined)", ->
    it "return 'Invalid parameters' error", (done) ->
      MassiveGit.getBlobs undefined, (err, blobs) ->
        err.should.exist
        err.should.have.property "message", "Invalid parameters"
        err.should.have.property "statusCode", 422
        should.not.exist blobs
        done()


