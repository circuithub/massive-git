should     = require "should"
_          = require "underscore"
Blob       = require("../lib/objects/blob").Blob
TreeEntry  = require("../lib/objects/tree.entry").TreeEntry
MassiveGit = new (require("../lib/massive.git").MassiveGit)()


describe "create blob from massive git", ->
  blob1 = new Blob "blob-content"
  blob2 = MassiveGit.createBlob "blob-content"
  it "should works in the same way as invoking contructor", ->
    blob1.equals(blob2).should.be.ok

describe "create tree entry from massive git", ->
  blob1 = new Blob "blob-content"
  treeEntry1 = new TreeEntry "entry.json", blob1
  treeEntry2 = MassiveGit.createTreeEntry "entry.json", new Blob("blob-content")
  it "should works in the same way as invoking contructor", ->
    _.isEqual(treeEntry1.attributes(), treeEntry2.attributes()).should.be.ok
    _.isEqual(treeEntry1.name, treeEntry2.name).should.be.ok

