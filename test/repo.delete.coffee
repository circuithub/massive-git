should     = require "should"
_          = require "underscore"
MassiveGit = new (require("../lib/massive.git").MassiveGit)()
helper     = require "./helper/helper"

describe "repos manipulation:", ->
  repo1Name = "part-1-delete" + Math.floor(1000 * Math.random())
  repo2Name = "part-2-delete" + Math.floor(1000 * Math.random())
  username = "random-user" + Math.floor(1000 * Math.random())
  repo1Id = username + "$" + repo1Name
  repo2Id = username + "$" + repo2Name
  before (done) ->
    helper.createUserWithRepos username, repo1Name, "part", repo2Name, "part", done
  describe "get repos after creation", ->
    it "should return repos objects", (done) ->
      MassiveGit.getUserRepos username, (err, repos) ->
        repos.should.have.length 
        done err
    describe "delete existent repo", ->
      it "should return user object with update link property", (done) ->
        MassiveGit.deleteRepo repo1Id, username, (err, user) ->
          should.not.exist err
          user.links().should.have.length 1
          done err
      describe "get repos after 1 repo was deleted", ->
        it "should return correct array of repos", (done) ->
          MassiveGit.getUserRepos username, (err, repos) ->
            repos.should.have.length 1
            done err
   after (done) ->
     helper.deleteUserWithRepo username, repo2Id, done
           
