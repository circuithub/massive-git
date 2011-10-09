assert = require "assert"
Repo = require("../lib/objects/repo").Repo

exports.testCreateRepo = ->
  repo = new Repo("circuithub.com/anton/project1", "anton", "project")
  assert.equal "circuithub.com-anton-project1", repo.id()
  assert.equal "project", repo.type
  assert.equal "anton", repo.owner
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
  repo = new Repo("circuithub.com/anton/project1", "anton", "project", false)
  assert.equal "circuithub.com-anton-project1", repo.id()
  assert.equal "project", repo.type
  assert.equal "anton", repo.owner
  assert.ok !repo.public
  assert.isNull repo.forkedFrom

exports.testCreateForkedRepo = ->
  repo = new Repo("circuithub.com/anton/project1", "anton", "project", false, "circuithub.com-andrew-project1")
  assert.equal "circuithub.com-anton-project1", repo.id()
  assert.equal "project", repo.type
  assert.equal "anton", repo.owner
  assert.ok !repo.public
  assert.equal "circuithub.com-andrew-project1", repo.forkedFrom
  # test dao related methods
  assert.equal "project", repo.attributes().type
  assert.ok !repo.attributes().public
  assert.equal 2, repo.links().length
  ownerLink = repo.links()[0]
  assert.equal "users", ownerLink.bucket
  assert.equal "anton", ownerLink.key
  assert.equal "owner", ownerLink.tag
  forkedFromLink = repo.links()[1]
  assert.equal "repositories", forkedFromLink.bucket
  assert.equal "circuithub.com-andrew-project1", forkedFromLink.key
  assert.equal "forked_from", forkedFromLink.tag

