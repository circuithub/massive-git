should     = require "should"
MassiveGit = new (require("../lib/massive.git").MassiveGit)()
helper     = require "./helper/helper"

describe "MassiveGit#forkRepo()", ->
  partName = "part" + Math.floor(1000 * Math.random())
  forkedPartName = "forked-part" + Math.floor(1000 * Math.random())
  username = "random-user" + Math.floor(1000 * Math.random())
  repoId = username + "$" + partName
  forkedRepoId = username + "$" + forkedPartName
  before (done) ->
    helper.createUserWithRepo username, partName, "part", done
  describe "with same user", ->
    it "should return forked repo object", (done) ->
      MassiveGit.forkRepo repoId, forkedPartName, username, (err, forkedRepo) ->
        should.not.exist err
        forkedRepo.forkedFrom.should.equal repoId
        forkedRepo.id().should.equal forkedRepoId
        forkedRepo.should.have.property "name", forkedPartName
        forkedRepo.should.have.property "author", username
        forkedRepo.public.should.be.ok
        should.not.exist forkedRepo.commit
        done err
  describe "with another user", ->   
    forkedUsername = "another-user" + Math.floor(1000 * Math.random())
    before (done) ->
      helper.createUser forkedUsername, done
    it "should return forked repo object", (done) ->
      MassiveGit.forkRepo repoId, forkedPartName, forkedUsername, (err, forkedRepo) ->
        should.not.exist err
        forkedRepo.forkedFrom.should.equal repoId
        forkedRepo.id().should.equal forkedUsername + "$" + forkedPartName
        forkedRepo.should.have.property "name", forkedPartName
        forkedRepo.should.have.property "author", forkedUsername
        forkedRepo.public.should.be.ok
        should.not.exist forkedRepo.commit
        done err
    after (done) ->
      helper.deleteUser forkedUsername, done
  after (done) ->
    helper.deleteUserWithRepos username, repoId, forkedRepoId, done


  


