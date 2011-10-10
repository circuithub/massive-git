assert = require "assert"
Blob = require("../lib/objects/blob").Blob
Tree = require("../lib/objects/tree").Tree

exports.testCreatePlainTree = ->
  blob1 = new Blob("test-content", "anton-project1")
  blob2 = new Blob("1111", "anton-project1")
  entries = []
  entries.push { name : "symbol.json", value : blob2}
  entries.push { name : "datasheet.json", value : blob1}
  tree = new Tree(entries, "anton-project1")
  assert.equal "c5c119808287f1f63db40077b8b7a88c97cfcfeb", tree.id()
  assert.equal 2, tree.entries.length
  # test dao related methods
  assert.equal tree.entries, tree.attributes().entries


exports.testCreateHierarchicalTree = ->
  blob1 = new Blob("test-content", "anton-project1")
  blob2 = new Blob("1111", "anton-project1")
  subtreeEntries = []
  subtreeEntries.push { name : "symbol.json", value : blob2}
  subtree = new Tree(subtreeEntries, "anton-project1")
  assert.equal "4eb2725c1684d3186d57e2482492b283541b7080", subtree.id()
  assert.equal 1, subtree.entries.length
  entries ={}
  entries = []
  entries.push { name : "datasheet.json", value : blob1}
  entries.push { name : "js", value : subtree}
  tree = new Tree(entries, "anton-project1")
  assert.equal "aa23506c7f9225f4dca3fcb28111f198633bd71e", tree.id()
  assert.equal 2, tree.entries.length
  # test dao related methods
  assert.equal tree.entries, tree.attributes().entries

