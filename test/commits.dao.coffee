assert   = require "assert"
async    = require "async"
commitsDao = require("../lib/dao/commits.dao").newInstance()
Commit     = require("../lib/objects/commit").Commit


exports.testSaveCommit = ->
  # create new commit and save it
  step1 = (callback) ->
    commit = new Commit("tree-id", "parent-id", "anton", "andrew", "initial commit", "anton$project1")
    assert.equal "4ca68e7f293e0b7445beda64f0f8fe854682a0ac", commit.id()
    commitsDao.save commit, (err, data) ->
      assert.isUndefined err
      callback err, commit
  # get commit from db by id and compare with initial
  step2 = (commit, callback) ->
    commitsDao.get commit.id(), (err, commitFromDao) ->
      assert.isUndefined err
      assert.equal commit.id(), commitFromDao.id()
      assert.equal commit.type, commitFromDao.type
      assert.equal commit.content(), commitFromDao.content()
      assert.equal commit.repo, commitFromDao.repo
      assert.equal "tree-id", commitFromDao.tree
      assert.equal "parent-id", commitFromDao.parent
      assert.equal "anton", commitFromDao.author
      assert.equal "andrew", commitFromDao.committer
      assert.equal "initial commit", commitFromDao.message
      assert.deepEqual commit.links(), commitFromDao.links()
      assert.deepEqual commit.attributes(), commitFromDao.attributes()
      callback err
  async.waterfall [step1, step2], (err, results) ->
    # clear all temp data
    commitsDao.deleteAll()

