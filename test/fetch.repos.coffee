should     = require "should"
DbTestCase = require("./base/db.test.case").DbTestCase
Blob       = require("../lib/objects/blob").Blob
TreeEntry  = require("../lib/objects/tree.entry").TreeEntry
MassiveGit = new (require("../lib/massive.git").MassiveGit)()
helper     = require "./helper/helper"

exports.testCommit = (beforeExit) ->
  partName = "part" + Math.floor(1000 * Math.random())
  userName = "anton" + Math.floor(1000 * Math.random())
  repoId = userName + "$" + partName
  # create user with repo
  step1 = (callback) ->
    helper.createUserWithRepo userName, partName, "part", callback
  # get plain repos
  step2 = (repo, callback) ->
    MassiveGit.getUserRepos userName, (err, entries) ->
      should.not.exist err
      entries.should.have.length 1
      entries[0].id().should.equal repoId
      callback err
  testCase = new DbTestCase step1, step2
  testCase.run()
  beforeExit () -> testCase.tearDown()

