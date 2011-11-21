should    = require "should"
TestCase = require("./base/test.case").TestCase
treesDao  = require("../lib/dao/trees.dao").newInstance()
Blob      = require("../lib/objects/blob").Blob
Tree      = require("../lib/objects/tree").Tree
TreeEntry = require("../lib/objects/tree.entry").TreeEntry

exports.testSavePlainTree = (beforeExit) ->
  # create new tree and save it
  step1 = (callback) ->
    blob1 = new Blob("test-content", "anton$project1")
    blob2 = new Blob("1111", "anton$project1")
    entries = []
    entries.push  new TreeEntry("symbol.json", blob2).attributes()
    entries.push new TreeEntry("datasheet.json", blob1).attributes()
    tree = new Tree(entries, "anton$project1")
    tree.links().should.have.length 3
    tree.getLinks("blob").should.have.length 2
    treesDao.save tree, (err, data) ->
      should.not.exist err
      should.exist data
      callback err, tree
  # get tree from db by id and compare with initial
  step2 = (tree, callback) ->
    treesDao.get tree.id(), (err, treeFromDao) ->
      should.not.exist err
      treeFromDao.equals(tree).should.be.ok
      callback err, tree

  testCase = new TestCase [step1, step2]
  testCase.tearDown = -> treesDao.deleteAll()
  testCase.run()
  beforeExit () -> testCase.tearDown()

