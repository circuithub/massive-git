assert = require "assert"
Blob = require("../lib/objects/blob").Blob

exports.testCreateBlob = ->
  blob = new Blob("test-content", "anton-project1")
  assert.equal "0535cbee7fa4e0fef31389c68336ec6bcb5422b3", blob.id()
  assert.equal "blob", blob.type
  assert.equal "anton-project1", blob.repo
  assert.equal "test-content", blob.data
  assert.equal blob.content(), blob.data
  # test dao related methods
  assert.equal "blob", blob.attributes().type
  assert.equal 1, blob.links().length
  repoLink = blob.links()[0]
  assert.equal "repositories", repoLink.bucket
  assert.equal "anton-project1", repoLink.key
  assert.equal "repository", repoLink.tag
  assert.equal "anton-project1", blob.getLink "repository"

