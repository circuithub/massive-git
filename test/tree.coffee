assert = require "assert"
Blob = require("../lib/objects/blob").Blob
Tree = require("../lib/objects/tree").Tree

exports.testCreatePlainTree = ->
  blob1 = new Blob("test-content", "anton-project1")
  blob2 = new Blob("1111", "anton-project1")
  tree = new Tree([blob1, blob2], "anton-project1")
  assert.equal "4c487817ad6285382384d0ddca1cfcc7ccf29b40", tree.id()
  assert.equal 2, tree.entries.length

exports.testCreateHierarchicalTree = ->
  blob1 = new Blob("test-content", "anton-project1")
  blob2 = new Blob("1111", "anton-project1")
  subtree = new Tree([blob2], "anton-project1")
  assert.equal "e5703eef623188c5540d9ac3f203e069ed1382af", subtree.id()
  assert.equal 1, subtree.entries.length
  tree = new Tree([blob1, subtree], "anton-project1")
  assert.equal "cd71f7398a2bf6a16bbb9be67eaf086585457406", tree.id()
  assert.equal 2, tree.entries.length

