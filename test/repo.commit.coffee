should     = require "should"
_          = require "underscore"
Repo       = require("../lib/objects/repo").Repo
Blob       = require("../lib/objects/blob").Blob
TreeEntry  = require("../lib/objects/tree.entry").TreeEntry
MassiveGit = new (require("../lib/massive.git").MassiveGit)()
helper     = require "./helper/helper"

describe "MassiveGit", ->
  blob1 = new Blob "test-content"
  blob2 = new Blob "1111"
  repo1Name = "repo1" + Math.floor(1000 * Math.random())
  username = "random-user" + Math.floor(100000 * Math.random())
  repo1Id = username + "$" + repo1Name
  before (done) ->
    helper.createUserWithRepo username, repo1Name, "part", done
  describe "#commit() two entries", ->
    entries = [new TreeEntry("symbol.json", blob2), new TreeEntry("datasheet.json", blob1)]
    it "should just normaly commit them", (done) ->
      MassiveGit.commit entries, repo1Id, username, "first commit", undefined, done
    describe "and then MassiveGit#getRepo() and MassiveGit#fetchRootEntries()", ->
      it "should return two files", (done) ->
        MassiveGit.getRepo repo1Id, (err, repo) ->
          commit = repo.getLink("commit")
          MassiveGit.fetchRootEntriesForCommit commit, (err, entries) ->
            console.log "CC>>", commit, entries, repo, err
            should.not.exist err
            console.log "fetching entries for commit", commit, entries
            entries.should.have.length 2
            blob1Copy = (entry.entry for entry in entries when entry.name == "datasheet.json")[0]
            blob2Copy = (entry.entry for entry in entries when entry.name == "symbol.json")[0]
            blob1Copy.equals(blob1).should.be.ok
            blob2Copy.equals(blob2).should.be.ok
            done err
    describe "and then MassiveGit#getRepo() and MassiveGit#getCommit()", ->
      it "should return two files", (done) ->
        MassiveGit.getRepo repo1Id, (err, repo) ->
          commit = repo.getLink("commit")
          MassiveGit.getCommit commit, (err, commit) ->
            should.not.exist err
            commit.should.have.property "author", username
            commit.should.have.property "committer", username
            commit.should.have.property "message", "first commit"
            commit.should.have.property "repo", repo1Id
            commit.authoredDate.should.exist
            commit.commitedDate.should.exist
            console.log "COMMIT", commit
            should.not.exist commit.parent
            should.not.exist commit.getLink "parent"
            done err


     

