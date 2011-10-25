should   = require "should"
TestCase = require("./base/test.case").TestCase
blobsDao = require("../lib/dao/blobs.dao").newInstance()
Blob     = require("../lib/objects/blob").Blob

exports.testSaveBlob = ->
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
  testCase = new TestCase [step1, step2], (err, results) ->
    # clear all temp data
    blobsDao.deleteAll()
  testCase.run()

