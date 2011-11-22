should     = require "should"
_          = require "underscore"
Blob       = require("../lib/objects/blob").Blob
TreeEntry  = require("../lib/objects/tree.entry").TreeEntry
MassiveGit = new (require("../lib/massive.git").MassiveGit)()

exports.testCreateBlob = ->
  blob1 = new Blob "blob-content"
  blob2 = MassiveGit.createBlob "blob-content"
  blob1.equals(blob2).should.be.ok

exports.testCreateTreeEntry = ->
  blob1 = new Blob "blob-content"
  treeEntry1 = new TreeEntry "entry.json", blob1
  treeEntry2 = MassiveGit.createTreeEntry "entry.json", "blob-content"
  _.isEqual(treeEntry1.attributes(), treeEntry2.attributes()).should.be.ok
  _.isEqual(treeEntry1.name, treeEntry2.name).should.be.ok

