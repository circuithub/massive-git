should     = require "should"
DbTestCase = require("./base/db.test.case").DbTestCase
_          = require "underscore"
Repo       = require("../lib/objects/repo").Repo
Blob       = require("../lib/objects/blob").Blob
TreeEntry  = require("../lib/objects/tree.entry").TreeEntry
MassiveGit = new (require("../lib/massive.git").MassiveGit)()
helper     = require "./helper/helper"

exports.testCommit = (beforeExit) ->
  blob1 = new Blob "test-content"
  blob2 = new Blob "1111"
  randomPartName = "part" + Math.floor(1000 * Math.random())
  # create user with repo
  step1 = (callback) ->
    helper.createUserWithRepo "anton", randomPartName, "part", callback
  # get plain repos
  step2 = (repo, callback) ->
    MassiveGit.getUserRepos "anton", "part", (err, entries) ->
      should.not.exist err
      entries.should.have.length 1
      entries[0].id().should.equal "anton$" + randomPartName
      callback err
  testCase = new DbTestCase [step1, step2]
  testCase.run()
  beforeExit () -> testCase.tearDown()

