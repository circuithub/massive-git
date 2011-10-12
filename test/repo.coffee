assert = require "assert"
Repo = require("../lib/objects/repo").Repo

exports.testCreateRepo = ->
  repo = new Repo("project1", "anton", "project")
  assert.equal "anton$project$project1", repo.id()
  assert.equal "project", repo.type
  assert.equal "anton", repo.author
  assert.equal "project1", repo.name
  assert.ok repo.public
  assert.isNull repo.forkedFrom
  # test dao related methods
  assert.equal "project", repo.attributes().type
  assert.ok repo.attributes().public
  assert.equal 1, repo.links().length
  authorLink = repo.links()[0]
  assert.equal "users", authorLink.bucket
  assert.equal "anton", authorLink.key
  assert.equal "author", authorLink.tag

exports.testCreatePrivateRepo = ->
  repo = new Repo("project1", "anton", "project", false)
  assert.equal "anton$project$project1", repo.id()
  assert.equal "project", repo.type
  assert.equal "anton", repo.author
  assert.equal "project1", repo.name
  assert.ok !repo.public
  assert.isNull repo.forkedFrom

exports.testCreateForkedRepo = ->
  repo = new Repo("project1", "anton", "project", false, null, "andrew$project$project1")
  assert.equal "anton$project$project1", repo.id()
  assert.equal "project", repo.type
  assert.equal "anton", repo.author
  assert.equal "project1", repo.name
  assert.ok !repo.public
  assert.equal "andrew$project$project1", repo.forkedFrom
  # test dao related methods
  assert.equal "project", repo.attributes().type
  assert.ok !repo.attributes().public
  assert.equal 2, repo.links().length
  authorLink = repo.links()[0]
  assert.equal "users", authorLink.bucket
  assert.equal "anton", authorLink.key
  assert.equal "author", authorLink.tag
  assert.equal "anton", repo.getLink "author"
  forkedFromLink = repo.links()[1]
  assert.equal "repositories", forkedFromLink.bucket
  assert.equal "andrew$project$project1", forkedFromLink.key
  assert.equal "forked_from", forkedFromLink.tag
  assert.equal "andrew$project$project1", repo.getLink "forked_from"

exports.testOldRepo = ->
  repo = new Repo("project1", "anton", "project", false, "4ca68e7f293e0b7445beda64f0f8fe854682a0ac")
  assert.equal "anton$project$project1", repo.id()
  assert.equal "project", repo.type
  assert.equal "anton", repo.author
  assert.equal "project1", repo.name
  assert.ok !repo.public
  assert.equal "4ca68e7f293e0b7445beda64f0f8fe854682a0ac", repo.commit
  # test dao related methods
  assert.equal "project", repo.attributes().type
  assert.ok !repo.attributes().public
  assert.equal 2, repo.links().length
  authorLink = repo.links()[0]
  assert.equal "users", authorLink.bucket
  assert.equal "anton", authorLink.key
  assert.equal "author", authorLink.tag
  assert.equal "anton", repo.getLink "author"
  commitLink = repo.links()[1]
  assert.equal "objects", commitLink.bucket
  assert.equal "4ca68e7f293e0b7445beda64f0f8fe854682a0ac", commitLink.key
  assert.equal "commit", commitLink.tag
  assert.equal "4ca68e7f293e0b7445beda64f0f8fe854682a0ac", repo.getLink "commit"

