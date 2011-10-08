assert = require "assert"
Repo = require("../lib/repo").Repo

exports.testNewPublicRepo = ->
  repo = new Repo("circuithub.com/anton/project1", "project")
  assert.equal "circuithub.com/anton/project1", repo.id
  assert.equal "project", repo.type
  assert.ok repo.public
  assert.isNull repo.forked_from

exports.testNewPrivateRepo = ->
  repo = new Repo("circuithub.com/anton/project2", "project", false)
  assert.equal "circuithub.com/anton/project2", repo.id
  assert.equal "project", repo.type
  assert.ok !repo.public
  assert.isNull repo.forked_from

exports.testNewForkedPublicRepo = ->
  repo = new Repo("circuithub.com/anton/project1", "project", true, "circuithub.com/andrew/project1")
  assert.equal "circuithub.com/anton/project1", repo.id
  assert.equal "project", repo.type
  assert.ok repo.public
  assert.equal "circuithub.com/andrew/project1", repo.forked_from

