assert = require "assert"
Commit = require("../lib/objects/commit").Commit

exports.testCreateCommit = ->
  commit = new Commit("tree-id", "parent-id", "anton", "andrew", "initial commit", "anton$project1")
  assert.equal "4ca68e7f293e0b7445beda64f0f8fe854682a0ac", commit.id()
  assert.equal "commit", commit.type
  assert.equal "tree-id", commit.tree
  assert.equal "parent-id", commit.parent
  assert.equal "anton", commit.author
  assert.equal "andrew", commit.committer
  assert.equal "initial commit", commit.message
  assert.equal "anton$project1", commit.repo
  # test dao related methods
  assert.equal "commit", commit.attributes().type
  assert.equal 5, commit.links().length
  repoLink = commit.links()[0]
  assert.equal "repositories", repoLink.bucket
  assert.equal "anton$project1", repoLink.key
  assert.equal "repository", repoLink.tag
  assert.equal "anton$project1", commit.getLink "repository"
  treeLink = commit.links()[1]
  assert.equal "objects", treeLink.bucket
  assert.equal "tree-id", treeLink.key
  assert.equal "tree", treeLink.tag
  assert.equal "tree-id", commit.getLink "tree"
  parentLink = commit.links()[2]
  assert.equal "objects", parentLink.bucket
  assert.equal "parent-id", parentLink.key
  assert.equal "parent", parentLink.tag
  assert.equal "parent-id", commit.getLink "parent"
  authorLink = commit.links()[3]
  assert.equal "users", authorLink.bucket
  assert.equal "anton", authorLink.key
  assert.equal "author", authorLink.tag
  assert.equal "anton", commit.getLink "author"
  committerLink = commit.links()[4]
  assert.equal "users", committerLink.bucket
  assert.equal "andrew", committerLink.key
  assert.equal "committer", committerLink.tag
  assert.equal "andrew", commit.getLink "committer"

