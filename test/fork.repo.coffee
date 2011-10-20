should     = require "should"
async      = require "async"
_          = require "underscore"
Repo       = require("../lib/objects/repo").Repo
Blob       = require("../lib/objects/blob").Blob
TreeEntry  = require("../lib/objects/tree.entry").TreeEntry
reposDao   = require("../lib/dao/repos.dao").newInstance()
commitsDao = require("../lib/dao/commits.dao").newInstance()
blobsDao   = require("../lib/dao/blobs.dao").newInstance()
treesDao   = require("../lib/dao/trees.dao").newInstance()
usersDao   = require("../lib/dao/users.dao").newInstance()
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
      forked.repo.should.have.property "name", "new-project-name"
      forked.repo.should.have.property "public", "anton"
      forked.public.should.be.ok
      forkedRepo.commit.should.be.equal repo.commit
  async.waterfall [step1, step2], (err, results) ->
    helper.deleteAll()

exports.testForkRepoWithAnotherUser = ->
  # create user with repo
  step1 = (callback) ->
    helper.createUserWithRepo "anton", "project1", "project", callback
  # fork repo
  step2 = (repo, callback) ->
    MassiveGit.forkRepo repo.id(), "new-project-name", "andrew", (err, forkedRepo) ->
      should.not.exist err
      forkedRepo.forkedFrom.should.equal repo.id()
      forkedRepo.id().should.equal "andrew$new-project-name"
      forked.repo.should.have.property "name", "new-project-name"
      forked.repo.should.have.property "public", "andrew"
      forked.public.should.be.ok
      forkedRepo.commit.should.be.equal repo.commit
  async.waterfall [step1, step2], (err, results) ->
    helper.deleteAll()

