assert = require "assert"
Repo = require("../lib/objects/repo").Repo

exports.testCreateRepo = ->
  repo = new Repo("circuithub.com/anton/project1", "anton", "project")
  assert.equal "circuithub.com/anton/project1", repo.id()
  assert.equal "project", repo.type
  assert.equal "anton", repo.owner
  assert.ok repo.public
  assert.isNull repo.forkedFrom

exports.testCreatePrivateRepo = ->
  repo = new Repo("circuithub.com/anton/project1", "anton", "project", false)
  assert.equal "circuithub.com/anton/project1", repo.id()
  assert.equal "project", repo.type
  assert.equal "anton", repo.owner
  assert.ok !repo.public
  assert.isNull repo.forkedFrom


exports.testCreateForkedRepo = ->
  repo = new Repo("circuithub.com/anton/project1", "anton", "project", false, "circuithub.com/andrew/project1")
  assert.equal "circuithub.com/anton/project1", repo.id()
  assert.equal "project", repo.type
  assert.equal "anton", repo.owner
  assert.ok !repo.public
  assert.equal "circuithub.com/andrew/project1", repo.forkedFrom

