assert   = require "assert"
async     = require "async"
treesDao  = require("../lib/dao/trees.dao").newInstance()
Blob      = require("../lib/objects/blob").Blob
Tree      = require("../lib/objects/tree").Tree
TreeEntry = require("../lib/objects/tree.entry").TreeEntry

exports.testSavePlainTree = ->
  # create new tree and save it
  step1 = (callback) ->
    blob1 = new Blob("test-content", "anton$project1")
    blob2 = new Blob("1111", "anton$project1")
    entries = []
    entries.push  new TreeEntry("symbol.json", blob2).attributes()
    entries.push new TreeEntry("symbol.json", blob2).attributes()
    tree = new Tree(entries, "anton$project1")
    assert.equal "9e67555764a6d2006c0f2af265656bad4cd1c5f9", tree.id()
    treesDao.save tree, (err, data) ->
      assert.isUndefined err
      callback err, tree
  # get tree from db by id and compare with initial
  step2 = (tree, callback) ->
    treesDao.get tree.id(), (err, treeFromDao) ->
      assert.isUndefined err
      assert.equal tree.id(), treeFromDao.id()
      assert.equal tree.type, treeFromDao.type
      assert.equal tree.content(), treeFromDao.content()
      assert.equal tree.repo, treeFromDao.repo
      assert.deepEqual tree.links(), treeFromDao.links()
      assert.deepEqual tree.attributes(), treeFromDao.attributes()
      callback err
  async.waterfall [step1, step2], (err, results) ->
    # clear all temp data
    treesDao.deleteAll()

