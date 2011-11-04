should   = require "should"
fs       = require "fs"
TestCase = require("./base/test.case").TestCase
blobsDao = require("../lib/dao/blobs.dao").newInstance()
Blob     = require("../lib/objects/blob").Blob

exports.testSaveBlob = (beforeExit) ->
  # create new blob and save it
  step1 = (callback) ->
    blob = new Blob("test-content", "anton$project1")
    blob.id().should.equal "0535cbee7fa4e0fef31389c68336ec6bcb5422b3"
    blobsDao.save blob, (err, data) ->
      should.not.exist err
      should.exist data
      callback err, blob
  # get blob from db by id and compare with initial
  step2 = (blob, callback) ->
    blobsDao.get blob.id(), (err, blobFromDao) ->
      should.not.exist err
      blobFromDao.equals(blob).should.be.ok
      callback err
  testCase = new TestCase [step1, step2]
  testCase.tearDown = ->  blobsDao.deleteAll()
  testCase.run()
  beforeExit () -> testCase.tearDown()

exports.testSavePng = (beforeExit) ->
  # create new blob and save it
  step1 = (callback) ->
    png = fs.readFileSync "./test/fixtures/test.png"
    blob = new Blob(png, "anton$project1")
    blob.contentType = "png"
    blob.id().should.equal "79d667ee1a34cb6a4cef6e99f41439db2392108c"
    blobsDao.save blob, (err, data) ->
      should.not.exist err
      should.exist data
      callback err, blob
  # get blob from db by id and compare with initial
  step2 = (blob, callback) ->
    blobsDao.get blob.id(), (err, blobFromDao) ->
      should.not.exist err
      blobFromDao.id().should.equal blob.id()
      callback err
  testCase = new TestCase [step1, step2]
  testCase.tearDown = ->  blobsDao.deleteAll()
  testCase.run()
  beforeExit () -> testCase.tearDown()

