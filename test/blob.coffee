should = require "should"
Blob   = require("../lib/objects/blob").Blob

# test blob object
blob = new Blob("test-content", "anton$project1")

exports.testBlobProperties = ->
  blob.id().should.equal "0535cbee7fa4e0fef31389c68336ec6bcb5422b3"
  blob.should.have.property "type", "blob"
  blob.should.have.property "repo", "anton$project1"
  blob.should.have.property "data", "test-content"
  blob.content().should.equal blob.data
  blob.attributes().should.have.property "type", "blob"

exports.testBlobLinks = ->
  blob.links().should.have.length(1)
  repoLink = blob.links()[0]
  repoLink.should.have.property "bucket", "repositories"
  repoLink.should.have.property "key", "anton$project1"
  repoLink.should.have.property "tag", "repository"
  blob.getLink("repository").should.equal "anton$project1"

