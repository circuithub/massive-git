assert   = require "assert"
async    = require "async"
blobsDao = require("../lib/dao/blobs.dao").newInstance()
Blob     = require("../lib/objects/blob").Blob


exports.testSaveBlob = ->
  # create new blob and save it
  step1 = (callback) ->
    blob = new Blob("test-content", "anton$project$project1")
    assert.equal "0535cbee7fa4e0fef31389c68336ec6bcb5422b3", blob.id()
    blobsDao.save blob, (err, data) ->
      assert.isUndefined err
      callback err, blob
  # get blob from db by id and compare with initial
  step2 = (blob, callback) ->
    blobsDao.get blob.id(), (err, blobFromDao) ->
      assert.isUndefined err
      assert.equal blob.id(), blobFromDao.id()
      assert.equal blob.type, blobFromDao.type
      assert.equal blob.data, blobFromDao.data
      assert.equal blob.content(), blobFromDao.content()
      assert.equal blob.getRepository(), blobFromDao.getRepository()
      assert.deepEqual blob.links(), blobFromDao.links()
      assert.deepEqual blob.attributes(), blobFromDao.attributes()
      callback err
  async.waterfall [step1, step2], (err, results) ->
    # clear all temp data
    blobsDao.deleteAll()

