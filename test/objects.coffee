assert = require "assert"
Blob = require("../lib/objects").Blob

exports.testCreateBlob = ->
  blob = new Blob("test-content", "circuithub.com/anton/project1")
  assert.equal "0535cbee7fa4e0fef31389c68336ec6bcb5422b3", blob.id()
  assert.equal "blob", blob.type
  assert.equal "circuithub.com/anton/project1", blob.repo
  assert.equal "test-content", blob.data

