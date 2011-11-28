should   = require "should"
fs       = require "fs"
blobsDao = require("../lib/dao/blobs.dao").newInstance()
Blob     = require("../lib/objects/blob").Blob

describe "BlobsDao", ->
  describe "#get() text blob after #save()", ->
    blob = new Blob("test-content", "anton$project1")
    before (done) ->
      blobsDao.save blob, (err, data) ->
        should.not.exist err
        should.exist data
        done err
    it "return matching object", (done) ->
      blobsDao.get blob.id(), (err, blobFromDao) ->
        console.log "XXX", err, blobFromDao, blob
        should.not.exist err
        blobFromDao.equals(blob).should.be.ok
        done err
    after (done) -> 
      blobsDao.deleteAll()
      done()
  describe "#get() png blob after #save()", ->
    png = fs.readFileSync "./test/fixtures/test.png"
    blob = new Blob(png, "anton$project1")
    blob.contentType = "png"
    before (done) ->
      blobsDao.save blob, (err, data) ->
        should.not.exist err
        should.exist data
        done err
    it "return matching object", (done) ->
      blobsDao.get blob.id(), (err, blobFromDao) ->
        should.not.exist err
        blobFromDao.id().should.equal blob.id()
        done err
    after (done) -> 
      blobsDao.deleteAll()
      done()

