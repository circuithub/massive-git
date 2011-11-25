should   = require "should"
fs       = require "fs"
blobsDao = require("../lib/dao/blobs.dao").newInstance()
Blob     = require("../lib/objects/blob").Blob

describe "save", ->
  describe "text blob", ->
    blob = new Blob("test-content", "anton$project1")
    before (done) ->
      blobsDao.save blob, (err, data) ->
        should.not.exist err
        should.exist data
        done err
    it "retrieve by id", (done) ->
      blobsDao.get blob.id(), (err, blobFromDao) ->
        should.not.exist err
        blobFromDao.equals(blob).should.be.ok
        done err
    after (done) -> 
      blobsDao.deleteAll()
      done()
  describe "png blob", ->
    png = fs.readFileSync "./test/fixtures/test.png"
    blob = new Blob(png, "anton$project1")
    blob.contentType = "png"
    before (done) ->
      blobsDao.save blob, (err, data) ->
        should.not.exist err
        should.exist data
        done err
    it "retrieve by id", (done) ->
      blobsDao.get blob.id(), (err, blobFromDao) ->
        should.not.exist err
        blobFromDao.id().should.equal blob.id()
        done err
    after (done) -> 
      blobsDao.deleteAll()
      done()


