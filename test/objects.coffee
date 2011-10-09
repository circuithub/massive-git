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
  # test dao related methods
  assert.equal "blob", blob.attributes().type
  assert.equal 1, blob.links().length
  repoLink = blob.links()[0]
  assert.equal "repositories", repoLink.bucket
  assert.equal "circuithub.com/anton/project1", repoLink.key
  assert.equal "repository", repoLink.tag

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
  # test dao related methods
  assert.equal "commit", commit.attributes().type
  assert.equal 5, commit.links().length
  repoLink = commit.links()[0]
  assert.equal "repositories", repoLink.bucket
  assert.equal "circuithub.com/anton/project1", repoLink.key
  assert.equal "repository", repoLink.tag
  treeLink = commit.links()[1]
  assert.equal "objects", treeLink.bucket
  assert.equal "tree-id", treeLink.key
  assert.equal "tree", treeLink.tag
  parentLink = commit.links()[2]
  assert.equal "objects", parentLink.bucket
  assert.equal "parent-id", parentLink.key
  assert.equal "parent", parentLink.tag
  authorLink = commit.links()[3]
  assert.equal "users", authorLink.bucket
  assert.equal "anton", authorLink.key
  assert.equal "author", authorLink.tag
  committerLink = commit.links()[4]
  assert.equal "users", committerLink.bucket
  assert.equal "andrew", committerLink.key
  assert.equal "committer", committerLink.tag

