should    = require "should"
treesDao  = require("../lib/dao/trees.dao").newInstance()
Blob      = require("../lib/objects/blob").Blob
Tree      = require("../lib/objects/tree").Tree
TreeEntry = require("../lib/objects/tree.entry").TreeEntry

describe "TreesDao", ->
  blob1 = new Blob("test-content", "anton$project1")
  blob2 = new Blob("1111", "anton$project1")
  entries = []
  entries.push  new TreeEntry("symbol.json", blob2).attributes()
  entries.push new TreeEntry("datasheet.json", blob1).attributes()
  tree = new Tree(entries, "anton$project1")
  describe "#get() after #save()", ->
    before (done) ->
      treesDao.save tree, (err, data) ->
        should.not.exist err
        should.exist data
        done()
    it "return matching object", (done) ->
      treesDao.get tree.id(), (err, treeFromDao) ->
        should.not.exist err
        treeFromDao.equals(tree).should.be.ok
        done err
    after (done) ->
      treesDao.remove tree.id(), done
