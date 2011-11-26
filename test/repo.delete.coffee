should     = require "should"
_          = require "underscore"
MassiveGit = new (require("../lib/massive.git").MassiveGit)()
helper     = require "./helper/helper"

describe "MassiveGit", ->
  repo1Name = "part-1-delete" + Math.floor(1000 * Math.random())
  repo2Name = "part-2-delete" + Math.floor(1000 * Math.random())
  username = "random-user" + Math.floor(1000 * Math.random())
  repo1Id = username + "$" + repo1Name
  repo2Id = username + "$" + repo2Name
  before (done) ->
    helper.createUserWithRepos username, repo1Name, "part", repo2Name, "part", done
  describe "#deleteRepo()", ->
    describe "fake repo", ->
      it "should return error 'Repo wasn't found'", (done) ->
        MassiveGit.deleteRepo "fake-repo-name$fake-username", username, (err, user) ->
          err.should.have.property "message", "Repo wasn't found"
          err.should.have.property "statusCode", 400
          done()
    describe "existent repo", ->
      it "should return user object with update link property", (done) ->
        MassiveGit.deleteRepo repo1Id, username, (err, user) ->
          should.not.exist err
          user.links().should.have.length 1
          done err
      describe "MassiveGit#getUserRepos()", ->
        it "should return correct array of repos", (done) ->
          MassiveGit.getUserRepos username, (err, repos) ->
            repos.should.have.length 1
            done err
   after (done) ->
     helper.deleteUserWithRepo username, repo2Id, done
           
