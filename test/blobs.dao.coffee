assert   = require "assert"
async    = require "async"
blobsDao = require("../lib/dao/blobs.dao").newInstance()
Blob     = require("../lib/objects").Blob


exports.testSaveBlob = ->
  step1 = (callback) ->
    blob = new Blob("test-content", "circuithub.com/anton/project1")
    assert.equal "0535cbee7fa4e0fef31389c68336ec6bcb5422b3", blob.id()
    blobsDao.save blob, (err, data) ->
      assert.isUndefined err
      console.log err, data
      callback err, data
  async.waterfall [step1], (err, results) ->
    # clear all temp data
    blobsDao.deleteAll()

