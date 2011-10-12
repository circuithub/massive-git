assert     = require "assert"
async      = require "async"
_          = require "underscore"
Repo       = require("../lib/objects/repo").Repo
Blob       = require("../lib/objects/blob").Blob
TreeEntry  = require("../lib/objects/tree.entry").TreeEntry
reposDao   = require("../lib/dao/repos.dao").newInstance()
commitsDao = require("../lib/dao/commits.dao").newInstance()
blobsDao = require("../lib/dao/blobs.dao").newInstance()
treesDao   = require("../lib/dao/trees.dao").newInstance()
MassiveGit = new (require("../lib/massive.git").MassiveGit)()

exports.testCommit = ->
  blob1 = new Blob "test-content"
  blob2 = new Blob "1111"
  # create repo
  step1 = (callback) ->
    MassiveGit.initRepo "part1", "anton", "part", (err, repo) ->
      assert.isUndefined err
      assert.equal "anton$part$part1", repo.id()
      callback err, repo
  # commit two files
  step2 = (repo, callback) ->
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
      assert.equal "anton$part$part1", commit.repo
      assert.equal "anton$part$part1", commit.getLink "repository"
      assert.isDefined commit.authoredDate
      assert.isDefined commit.commitedDate
      assert.isDefined commit.tree
      # todo (anton) why there is problem with missing link??? fix it!!!
      #assert.isUndefined commit.parent
      #assert.isNull commit.getLink "parent"
      callback err, commit
  # get repo and check it
  step4 = (commit, callback) ->
    reposDao.get "anton$part$part1", (err, repo) ->
      assert.isUndefined err
      console.log repo
      assert.equal "part1", repo.name
      assert.equal "anton", repo.owner
      assert.equal "anton", repo.getLink "owner"
      assert.equal "part", repo.type
      assert.equal commit.id(), repo.commit
      assert.equal commit.id(), repo.getLink "commit"
      assert.isNull repo.forkedFrom
      assert.isNull repo.getLink "forked_from"
      assert.ok repo.public
      callback err, commit.tree
   # get tree and check it
  step5 = (treeId, callback) ->
    treesDao.get treeId, (err, tree) ->
      assert.isUndefined err
      assert.equal "anton$part$part1", tree.repo
      assert.equal "anton$part$part1", tree.getLink "repository"
      assert.equal 2, tree.getLinks("blob").length
      assert.equal blob1.id(), tree.getLinks("blob")[0]
      assert.equal blob2.id(), tree.getLinks("blob")[1]
      callback err, blob1, blob2
  # get blob 1 and check it
  step6 = (blob1, blob2, callback) ->
    blobsDao.get blob1.id(), (err, blob) ->
      assert.isUndefined err
      assert.deepEqual blob1.attributes(), blob.attributes()
      assert.deepEqual blob1.links(), blob.links()
      callback err, blob2
  # get blob 2 and check it
  step7 = (blob2, callback) ->
    blobsDao.get blob2.id(), (err, blob) ->
      assert.isUndefined err
      assert.deepEqual blob2.attributes(), blob.attributes()
      assert.deepEqual blob2.links(), blob.links()
      callback err
  async.waterfall [step1, step2, step3, step4, step5, step6, step7], (err, results) ->
    # clear all temp data
    reposDao.deleteAll()
    commitsDao.deleteAll()
    treesDao.deleteAll()


exports.testFindRepos = ->
  # create repo with different type
  step0a = (callback) ->
    MassiveGit.initRepo "project1", "anton", "project", (err, repo) ->
      assert.isUndefined err
      assert.equal "anton$project$project1", repo.id()
      callback err
  # create repo with different user
  step0b = (callback) ->
    MassiveGit.initRepo "part1", "andrew", "part", (err, repo) ->
      assert.isUndefined err
      assert.equal "andrew$part$part1", repo.id()
      callback err
  # create first repo
  step1 = (callback) ->
    MassiveGit.initRepo "part1", "anton", "part", (err, repo) ->
      assert.isUndefined err
      assert.equal "anton$part$part1", repo.id()
      callback err, repo
  # create second repo
  step2 = (repo1, callback) ->
    MassiveGit.initRepo "part2", "anton", "part", (err, repo) ->
      assert.isUndefined err
      assert.equal "anton$part$part2", repo.id()
      callback err, repo1, repo
  # find repos
  step3 = (repo1, repo2, callback) ->
    MassiveGit.repos "anton", "part", (err, repos) ->
      assert.equal 2, repos.length
      repo1Copy = _.detect repos, (iterator) -> iterator.id() == repo1.id()
      repo2Copy = _.detect repos, (iterator) -> iterator.id() == repo2.id()
      assert.deepEqual repo1.id(), repo1Copy.id()
      assert.deepEqual repo1.attributes(), repo1Copy.attributes()
      assert.deepEqual repo1.links(), repo1Copy.links()
      assert.deepEqual repo2.id(), repo2Copy.id()
      assert.deepEqual repo2.attributes(), repo2Copy.attributes()
      assert.deepEqual repo2.links(), repo2Copy.links()
  async.waterfall [step0a, step0b, step1, step2, step3], (err, results) ->
    # clear all temp data
    reposDao.deleteAll()

