should     = require "should"
Blob       = require("../lib/objects/blob").Blob
TreeEntry  = require("../lib/objects/tree.entry").TreeEntry
MassiveGit = new (require("../lib/massive.git").MassiveGit)()
helper     = require "./helper/helper"

describe "MassiveGit#getUserRepos()", ->
  repoName = "repo" + Math.floor(1000 * Math.random())
  userName = "anton" + Math.floor(1000 * Math.random())
  repoId = userName + "$" + repoName
  before (done) ->
    helper.createUserWithRepo userName, repoName, "repo-type", done  
  it "should return 1 repo for provided real user", (done) ->
    MassiveGit.getUserRepos userName, (err, entries) ->
      should.not.exist err
      entries.should.have.length 1
      entries[0].id().should.equal repoId
      done err
  it "should return 0 repos for fake user", (done) ->
    MassiveGit.getUserRepos "fake-user", (err, entries) ->
      should.not.exist err
      entries.should.have.length 0
      done err
  after (done) ->
    helper.deleteUserWithRepo userName, repoId, done

