should     = require "should"
_          = require "underscore"
Repo       = require("../lib/objects/repo").Repo
Blob       = require("../lib/objects/blob").Blob
TreeEntry  = require("../lib/objects/tree.entry").TreeEntry
MassiveGit = new (require("../lib/massive.git").MassiveGit)()
helper     = require "./helper/helper"

describe "MassiveGit#commit()", ->
  blob1 = new Blob "test-content"
  blob2 = new Blob "1111"
  repo1Name = "repo1" + Math.floor(1000 * Math.random())
  username = "random-user" + Math.floor(100000 * Math.random())
  repo1Id = username + "$" + repo1Name
  before (done) ->
    helper.createUserWithRepo username, randomPart1Name, "part", done
  describe "commit two files", ->
    entries = [new TreeEntry("symbol.json", blob2), new TreeEntry("datasheet.json", blob1)]
    it "should just normally commit them", (done) ->
      MassiveGit.commit entries, repo1Id, username, "first commit", undefined, done
     

