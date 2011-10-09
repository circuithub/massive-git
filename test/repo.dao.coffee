assert   = require "assert"
async    = require "async"
reposDao = require("../lib/dao/repos.dao").newInstance()
Repo     = require("../lib/objects/repo").Repo


exports.testSaveRepo = ->
  # create new repo and save it
  step1 = (callback) ->
    repo = new Repo("circuithub.com/anton/project1", "anton", "project")
    assert.equal "0535cbee7fa4e0fef31389c68336ec6bcb5422b3", blob.id()
    console.log "a",blobsDao.populateEntity
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
      assert.equal blob.repo, blobFromDao.repo
      callback err
  async.waterfall [step1, step2], (err, results) ->
    # clear all temp data
    blobsDao.deleteAll()

