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
    entries.push new TreeEntry("datasheet.json", blob1).attributes()
    tree = new Tree(entries, "anton$project1")
    assert.equal "7a8b327d8ec3e00838b350a59887c4ae6c183928", tree.id()
    assert.equal 3, tree.links().length
    assert.equal 2, tree.getLinks("blob").length
    assert.equal blob1.id(), tree.getLinks("blob")[0]
    assert.equal blob2.id(), tree.getLinks("blob")[1]
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
      callback err, tree
  async.waterfall [step1, step2], (err, results) ->
    # clear all temp data
    treesDao.deleteAll()

