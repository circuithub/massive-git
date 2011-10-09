assert = require "assert"
Blob = require("../lib/objects").Blob
Commit = require("../lib/objects").Commit

exports.testCreateBlob = ->
  blob = new Blob("test-content", "circuithub.com/anton/project1")
  assert.equal "0535cbee7fa4e0fef31389c68336ec6bcb5422b3", blob.id()
  assert.equal "blob", blob.type
  assert.equal "circuithub.com/anton/project1", blob.repo
  assert.equal "test-content", blob.data
  assert.equal blob.content(), blob.data

exports.testCreateCommit = ->
  commit = new Commit("tree-id", "parent-id", "anton", "andrew", "initial commit", "circuithub.com/anton/project1")
  assert.equal "4ca68e7f293e0b7445beda64f0f8fe854682a0ac", commit.id()
  assert.equal "commit", commit.type
  assert.equal "tree-id", commit.tree
  assert.equal "parent-id", commit.parent
  assert.equal "anton", commit.author
  assert.equal "andrew", commit.committer
  assert.equal "initial commit", commit.message
  assert.equal "circuithub.com/anton/project1", commit.repo

