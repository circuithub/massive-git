should = require "should"
Repo   = require("../lib/objects/repo").Repo

exports.testCreateRepo = ->
  repo = new Repo("project1", "anton", "project")
  repo.id().should.equal "anton$project1"
  repo.should.have.property "type", "project"
  repo.should.have.property "author", "anton"
  repo.should.have.property "name", "project1"
  repo.public.should.be.ok
  should.not.exist repo.forkedFrom
  repo.attributes().should.have.property "type", "project"
  repo.attributes().public.should.be.ok
  repo.links().should.have.length(1)
  repo.getLink("author").should.equal "anton"

exports.testCreatePrivateRepo = ->
  repo = new Repo("project1", "anton", "project", false)
  repo.id().should.equal "anton$project1"
  repo.should.have.property "type", "project"
  repo.should.have.property "author", "anton"
  repo.should.have.property "name", "project1"
  repo.public.should.be.not.ok
  should.not.exist repo.forkedFrom

exports.testCreateForkedRepo = ->
  repo = new Repo("project1", "anton", "project", false, null, "andrew$project1")
  repo.id().should.equal "anton$project1"
  repo.should.have.property "type", "project"
  repo.should.have.property "author", "anton"
  repo.should.have.property "name", "project1"
  repo.public.should.be.not.ok
  repo.should.have.property "forkedFrom", "andrew$project1"
  repo.links().should.have.length(2)
  repo.getLink("author").should.equal "anton"
  repo.getLink("forked_from").should.equal "andrew$project1"

exports.testOldRepo = ->
  repo = new Repo("project1", "anton", "project", false, "4ca68e7f293e0b7445beda64f0f8fe854682a0ac")
  repo.id().should.equal "anton$project1"
  repo.should.have.property "type", "project"
  repo.should.have.property "author", "anton"
  repo.should.have.property "name", "project1"
  repo.public.should.be.not.ok
  repo.should.have.property "commit", "4ca68e7f293e0b7445beda64f0f8fe854682a0ac"
  repo.links().should.have.length(2)
  repo.getLink("author").should.equal "anton"
  repo.getLink("commit").should.equal "4ca68e7f293e0b7445beda64f0f8fe854682a0ac"

