should     = require "should"
async      = require "async"
MassiveGit = new (require("../lib/massive.git").MassiveGit)()
helper     = require "./fixture/helper"

exports.testForkRepoWithSameUser = ->
  # create user with repo
  step1 = (callback) ->
    helper.createUserWithRepo "anton", "project1", "project", callback
  # fork repo
  step2 = (repo, callback) ->
    MassiveGit.forkRepo repo.id(), "new-project-name", "anton", (err, forkedRepo) ->
      should.not.exist err
      forkedRepo.forkedFrom.should.equal repo.id()
      forkedRepo.id().should.equal "anton$new-project-name"
      forkedRepo.should.have.property "name", "new-project-name"
      forkedRepo.should.have.property "author", "anton"
      forkedRepo.public.should.be.ok
      should.not.exist forkedRepo.commit
  async.waterfall [step1, step2], (err, results) ->
    helper.deleteAll()

exports.testForkRepoWithAnotherUser = ->
  # create user
  step1 = (callback) ->
    helper.createUser "andrew", callback
  # create another user with repo
  step2 = (results, callback) ->
    helper.createUserWithRepo "anton", "project1", "project", callback
  # fork repo
  step3 = (repo, callback) ->
    MassiveGit.forkRepo repo.id(), "new-project-name", "andrew", (err, forkedRepo) ->
      should.not.exist err
      forkedRepo.forkedFrom.should.equal repo.id()
      forkedRepo.id().should.equal "andrew$new-project-name"
      forkedRepo.should.have.property "name", "new-project-name"
      forkedRepo.should.have.property "author", "andrew"
      forkedRepo.public.should.be.ok
      should.not.exist forkedRepo.commit

  async.waterfall [step1, step2, step3], (err, results) ->
    helper.deleteAll()

