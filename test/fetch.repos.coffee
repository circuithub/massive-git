should     = require "should"
DbTestCase = require("./base/db.test.case").DbTestCase
_          = require "underscore"
Repo       = require("../lib/objects/repo").Repo
Blob       = require("../lib/objects/blob").Blob
TreeEntry  = require("../lib/objects/tree.entry").TreeEntry
MassiveGit = new (require("../lib/massive.git").MassiveGit)()
helper     = require "./fixture/helper"

exports.testCommit = ->
  blob1 = new Blob "test-content"
  blob2 = new Blob "1111"
  # create user with repo
  step1 = (callback) ->
    randomPartName = "part" + Math.floor(1000 * Math.random())
    helper.createUserWithRepo "anton", randomPartName, "part", callback
  # get plain repos
  step2 = (repo, callback) ->
    MassiveGit.repos "anton", "part", (err, entries) ->
      console.log "Entries", entries
      should.not.exist err
      callback {}
  testCase = new DbTestCase [step1, step2]
  testCase.run()

