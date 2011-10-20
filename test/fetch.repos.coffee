should     = require "should"
async      = require "async"
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
    helper.createUserWithRepo "anton", "part1", "part", callback
  # commit two files
  step2 = (repo, callback) ->
    entries = [new TreeEntry("symbol.json", blob2), new TreeEntry("datasheet.json", blob1)]
    MassiveGit.commit entries, repo.id(), "anton", "first commit", undefined, (err, commitId) ->
      should.not.exist err
      callback err, commitId
  # get entries from commit
  step3 = (commitId, callback) ->
    MassiveGit.reposEntries "anton", "part", (err, entries) ->
      should.not.exist err
      console.log "DONEE>>", err, entries
  async.waterfall [step1, step2, step3], (err, results) ->
    helper.deleteAll()

