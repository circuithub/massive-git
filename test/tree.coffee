assert    = require "assert"
Blob      = require("../lib/objects/blob").Blob
Tree      = require("../lib/objects/tree").Tree
TreeEntry = require("../lib/objects/tree.entry").TreeEntry

exports.testCreatePlainTree = ->
  blob1 = new Blob("test-content", "anton$project1")
  blob2 = new Blob("1111", "anton-project1")
  entries = []
  entries.push new TreeEntry("symbol.json", blob2).attributes()
  entries.push new TreeEntry("datasheet.json", blob1).attributes()
  tree = new Tree(entries, "anton$project1")
  assert.equal "7a8b327d8ec3e00838b350a59887c4ae6c183928", tree.id()
  assert.equal 2, tree.entries.length
  # test dao related methods
  assert.equal tree.entries, tree.attributes().entries


exports.testCreateHierarchicalTree = ->
  blob1 = new Blob("test-content", "anton$project1")
  blob2 = new Blob("1111", "anton-project1")
  subtreeEntries = []
  subtreeEntries.push new TreeEntry("symbol.json", blob2).attributes()
  subtree = new Tree(subtreeEntries, "anton-project1")
  assert.equal "b1c610ed5d646a401e710d3a110d04431cfd231e", subtree.id()
  assert.equal 1, subtree.entries.length
  entries = []
  entries.push new TreeEntry("datasheet.json", blob1).attributes()
  entries.push new TreeEntry("js", subtree).attributes()
  tree = new Tree(entries, "anton$project1")
  assert.equal "260f756862c7fc027f275aaec07ba4fa2139b0e9", tree.id()
  assert.equal 2, tree.entries.length
  # test dao related methods
  assert.equal tree.entries, tree.attributes().entries

