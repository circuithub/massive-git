assert = require "assert"
Repo = require("../lib/objects/repo").Repo

exports.testCreateRepo = ->
  repo = new Repo("project1", "anton", "project")
  assert.equal "anton-project1", repo.id()
  assert.equal "project", repo.type
  assert.equal "anton", repo.owner
  assert.equal "project1", repo.name
  assert.ok repo.public
  assert.isNull repo.forkedFrom
  # test dao related methods
  assert.equal "project", repo.attributes().type
  assert.ok repo.attributes().public
  assert.equal 1, repo.links().length
  ownerLink = repo.links()[0]
  assert.equal "users", ownerLink.bucket
  assert.equal "anton", ownerLink.key
  assert.equal "owner", ownerLink.tag

exports.testCreatePrivateRepo = ->
  repo = new Repo("project1", "anton", "project", false)
  assert.equal "anton-project1", repo.id()
  assert.equal "project", repo.type
  assert.equal "anton", repo.owner
  assert.equal "project1", repo.name
  assert.ok !repo.public
  assert.isNull repo.forkedFrom

exports.testCreateForkedRepo = ->
  repo = new Repo("project1", "anton", "project", false, "andrew-project1")
  assert.equal "anton-project1", repo.id()
  assert.equal "project", repo.type
  assert.equal "anton", repo.owner
  assert.equal "project1", repo.name
  assert.ok !repo.public
  assert.equal "andrew-project1", repo.forkedFrom
  # test dao related methods
  assert.equal "project", repo.attributes().type
  assert.ok !repo.attributes().public
  assert.equal 2, repo.links().length
  ownerLink = repo.links()[0]
  assert.equal "users", ownerLink.bucket
  assert.equal "anton", ownerLink.key
  assert.equal "owner", ownerLink.tag
  assert.equal "anton", repo.getLink "owner"
  forkedFromLink = repo.links()[1]
  assert.equal "repositories", forkedFromLink.bucket
  assert.equal "andrew-project1", forkedFromLink.key
  assert.equal "forked_from", forkedFromLink.tag
  assert.equal "andrew-project1", repo.getLink "forked_from"

