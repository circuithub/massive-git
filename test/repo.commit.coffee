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
  randomPart1Name = "part1" + Math.floor(1000 * Math.random())
  # create user with repo
  [step1, step2] = helper.createUserWithRepo("anton", randomPart1Name, "part")
  # commit two files
  step3 = (repo, callback) ->
    entries = [new TreeEntry("symbol.json", blob2), new TreeEntry("datasheet.json", blob1)]
    MassiveGit.commit entries, repo.id(), "anton", "first commit", undefined, callback
  # get entries from commit
  step4 = (commitId, callback) ->
    MassiveGit.fetchRootEntriesForCommit commitId, (err, entries) ->
      should.not.exist err
      console.log "fetching entries for commit", commitId, entries
      entries.should.have.length 2
      blob1Copy = (entry.entry for entry in entries when entry.name == "datasheet.json")[0]
      blob2Copy = (entry.entry for entry in entries when entry.name == "symbol.json")[0]
      blob1Copy.equals(blob1).should.be.ok
      blob2Copy.equals(blob2).should.be.ok
      callback undefined, commitId
  # get commit and check it
  step5 = (commitId, callback) ->
    MassiveGit.getCommit commitId, (err, commit) ->
      should.not.exist err
      commit.should.have.property "author", "anton"
      commit.should.have.property "committer", "anton"
      commit.should.have.property "message", "first commit"
      commit.should.have.property "repo", "anton$part1"
      commit.authoredDate.should.exist
      commit.commitedDate.should.exist
      commit.tree.should.exist
      should.not.exist commit.parent
      should.not.exist commit.getLink "parent"
      callback err, commit
  # get repo and check it
  step6 = (commit, callback) ->
    MassiveGit.getRepo "anton$" + randomPart1Name, (err, repo) ->
      should.not.exist err
      repo.should.have.property "name", "part1"
      repo.should.have.property "author", "anton"
      repo.should.have.property "type", "part"
      repo.commit.should.equal commit.id()
      repo.getLink("commit").should.equal commit.id()
      should.not.exist repo.forkedFrom
      repo.public.should.be.ok
      callback err, commit.tree
  # get blobs from tree
  step7 = (treeId, callback) ->
    MassiveGit.getBlobs treeId, (err, blobs) ->
      should.not.exist err
      blobs.should.have.length 2
      blob1Copy = (blob for blob in blobs when blob.id() == blob1.id())[0]
      blob2Copy = (blob for blob in blobs when blob.id() == blob2.id())[0]
      blob1Copy.equals(blob1).should.be.ok
      blob2Copy.equals(blob2).should.be.ok
      callback err, treeId
  # get tree and check it
  step8 = (treeId, callback) ->
    MassiveGit.getTree treeId, (err, tree) ->
      should.not.exist err
      tree.should.have.property "repo", "anton$part1"
      tree.getLinks("blob").should.have.length 2
      tree.getLinks("blob")[0].should.equal blob1.id()
      tree.getLinks("blob")[1].should.equal blob2.id()
      callback err, blob1, blob2
  # get blob 1 and check it
  step9 = (blob1, blob2, callback) ->
    MassiveGit.getBlob blob1.id(), (err, blob) ->
      should.not.exist err
      blob.equals(blob1).should.be.ok
      callback err, blob2
  # get blob 2 and check it
  step10 = (blob2, callback) ->
    MassiveGit.getBlob blob2.id(), (err, blob) ->
      should.not.exist err
      blob.equals(blob2).should.be.ok
      callback err

  testCase = new DbTestCase [step1, step2, step3, step4, step5, step6, step7, step8, step9, step10]
  testCase.run()

