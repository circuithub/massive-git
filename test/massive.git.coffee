assert     = require "assert"
async      = require "async"
Repo       = require("../lib/objects/repo").Repo
Blob       = require("../lib/objects/blob").Blob
TreeEntry  = require("../lib/objects/tree.entry").TreeEntry
reposDao   = require("../lib/dao/repos.dao").newInstance()
commitsDao = require("../lib/dao/commits.dao").newInstance()
treesDao   = require("../lib/dao/trees.dao").newInstance()
MassiveGit = new (require("../lib/massive.git").MassiveGit)()

exports.testCommit = ->
  # create repo
  step1 = (callback) ->
    repo = new Repo("part1", "anton", "part")
    assert.equal "anton$part1", repo.id()
    reposDao.save repo, (err, data) ->
      assert.isUndefined err
      callback err, repo
  # commit two files
  step2 = (repo, callback) ->
    blob1 = new Blob "test-content"
    blob2 = new Blob "1111"
    entries = [new TreeEntry("symbol.json", blob2), new TreeEntry("datasheet.json", blob1)]
    MassiveGit.commit entries, repo.id(), "anton", "first commit", undefined, (err, commitId) ->
      assert.isUndefined err
      callback err, commitId
  # get commit and check it
  step3 = (commitId, callback) ->
    commitsDao.get commitId, (err, commit) ->
      assert.isUndefined err
      assert.equal "anton", commit.author
      assert.equal "anton", commit.getLink "author"
      assert.equal "anton", commit.committer
      assert.equal "anton", commit.getLink "committer"
      assert.equal "first commit", commit.message
      assert.equal "anton$part1", commit.repo
      assert.equal "anton$part1", commit.getLink "repository"
      assert.isDefined commit.authoredDate
      assert.isDefined commit.commitedDate
      assert.isDefined commit.tree
      # todo (anton) why there is problem with missing link??? fix it!!!
      #assert.isUndefined commit.parent
      #assert.isNull commit.getLink "parent"
      callback err, commit.tree
   # get tree and check it
  step4 = (treeId, callback) ->
    treesDao.get treeId, (err, tree) ->
      assert.isUndefined err
      console.log tree
      callback err
  # todo (anton) tree, repo and both blob should be checke.
  async.waterfall [step1, step2, step3, step4], (err, results) ->
    # clear all temp data
    reposDao.deleteAll()
    commitsDao.deleteAll()
    treesDao.deleteAll()

