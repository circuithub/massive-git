assert     = require "assert"
async      = require "async"
_          = require "underscore"
Repo       = require("../lib/objects/repo").Repo
Blob       = require("../lib/objects/blob").Blob
TreeEntry  = require("../lib/objects/tree.entry").TreeEntry
reposDao   = require("../lib/dao/repos.dao").newInstance()
commitsDao = require("../lib/dao/commits.dao").newInstance()
blobsDao   = require("../lib/dao/blobs.dao").newInstance()
treesDao   = require("../lib/dao/trees.dao").newInstance()
usersDao   = require("../lib/dao/users.dao").newInstance()
MassiveGit = new (require("../lib/massive.git").MassiveGit)()

exports.testCommit = ->
  blob1 = new Blob "test-content"
  blob2 = new Blob "1111"
  # create user
  step0 = (callback) ->
    MassiveGit.newUser "anton", "anton@circuithub.com", (err, user) ->
      assert.isUndefined err
      callback err, user
  # create repo
  step1 = (user, callback) ->
    MassiveGit.initRepo "part1", user.id(), "part", (err, repo) ->
      assert.isUndefined err
      assert.equal "anton$part1", repo.id()
      callback err, repo
  # commit two files
  step2 = (repo, callback) ->
    entries = [new TreeEntry("symbol.json", blob2), new TreeEntry("datasheet.json", blob1)]
    MassiveGit.commit entries, repo.id(), "anton", "first commit", undefined, (err, commitId) ->
      assert.isUndefined err
      callback err, commitId
  # get entries from commit
  step3 = (commitId, callback) ->
    MassiveGit.reposEntries "anton", "part", (err, entries) ->
      console.log "DONEE>>", err, entries
  async.waterfall [step0, step1, step2, step3], (err, results) ->
    # clear all temp data
    usersDao.deleteAll()
    reposDao.deleteAll()
    commitsDao.deleteAll()
    treesDao.deleteAll()

