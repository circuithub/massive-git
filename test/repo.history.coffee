should     = require "should"
_          = require "underscore"
Repo       = require("../lib/objects/repo").Repo
Blob       = require("../lib/objects/blob").Blob
TreeEntry  = require("../lib/objects/tree.entry").TreeEntry
MassiveGit = new (require("../lib/massive.git").MassiveGit)()
helper     = require "./helper/helper"

#
testCommitUpdate = (beforeExit) ->
  blob1 = new Blob JSON.stringify {one:1, two: 2}
  blob2 = new Blob "some-string"
  randomPartName = "part" + Math.floor(1000 * Math.random())
  repoId = "anton$" + randomPartName
  username = "un-for-history" + Math.floor(1000 * Math.random())
  # create user with repo
  step1 = (callback) ->
    helper.createUserWithRepo username, randomPartName, "part", callback
  # commit 1 file
  step2 = (repo, callback) ->
    blob = MassiveGit.createBlob(JSON.stringify({one:1, two: 2}), repo.id())
    entries = [MassiveGit.createTreeEntry "datasheet.json", blob]
    MassiveGit.commit entries, repo.id(), username, "first commit", undefined, callback
  # get entries from commit
  step3 = (commitId, callback) ->
    MassiveGit.fetchRootEntriesForCommit commitId, (err, entries) ->
      should.not.exist err
      entries.should.have.length 1
      blob1Copy = entries[0].entry
      _.isEqual(blob1Copy.data, blob1.data).should.be.ok
      callback undefined, commitId
  # get commit and check it
  step4 = (commitId, callback) ->
    MassiveGit.getCommit commitId, (err, commit) ->
      should.not.exist err
      commit.should.have.property "author", username
      commit.should.have.property "committer", username
      commit.should.have.property "message", "first commit"
      commit.should.have.property "repo", repoId
      commit.authoredDate.should.exist
      commit.commitedDate.should.exist
      commit.tree.should.exist
      callback err, commit
  # get blobs from tree
  step5 = (commit, callback) ->
    MassiveGit.getBlobs commit.tree, (err, blobs) ->
      should.not.exist err
      blobs.should.have.length 1
      blob1Copy = blobs[0]
      _.isEqual(blob1Copy.data, blob1.data).should.be.ok
      callback err, commit
  # get tree and check it
  step6 = (commit, callback) ->
    MassiveGit.getTree commit.tree, (err, tree) ->
      should.not.exist err
      tree.should.have.property "repo", repoId
      tree.getLinks("blob").should.have.length 1
      tree.getLinks("blob")[0].should.equal blob1.id()
      callback err, commit
  # commit new blob
  step7 = (commit, callback) ->
    entries = [MassiveGit.createTreeEntry "symbol.json", "some-string"]
    MassiveGit.addToIndex entries, repoId, "andrew", "add new file symbol.json", (err, commitId) ->
      should.not.exist err
      console.log "Commit>>", commit.id(), "updated to", commitId
      callback err, commitId
  # get commit and check it
  step8 = (commitId, callback) ->
    MassiveGit.getCommit commitId, (err, commit) ->
      should.not.exist err
      commit.should.have.property "author", "andrew"
      commit.should.have.property "committer", "andrew"
      commit.should.have.property "message", "add new file symbol.json"
      commit.should.have.property "repo", repoId
      commit.authoredDate.should.exist
      commit.commitedDate.should.exist
      commit.tree.should.exist
      callback err, commit
  # get entries for commit
  step9 = (commit, callback) ->
    MassiveGit.fetchRootEntriesForCommit commit.id(), (err, entries) ->
      should.not.exist err
      entries.should.have.length 2 # todo (anton) why we have 1 here???


