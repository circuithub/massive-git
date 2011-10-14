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
  # create repo
  step1 = (callback) ->
    MassiveGit.initRepo "part1", "anton", "part", (err, repo) ->
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
    MassiveGit.fetchRootEntriesForCommit commitId, (err, entries) ->
      assert.isUndefined err
      assert.equal 2, entries.length
      blob1Copy = (entry.entry for entry in entries when entry.name == "datasheet.json")[0]
      blob2Copy = (entry.entry for entry in entries when entry.name == "symbol.json")[0]
      assert.equal blob1.id(), blob1Copy.id()
      assert.deepEqual blob1.attributes(), blob1Copy.attributes()
      assert.deepEqual blob1.links(), blob1Copy.links()
      assert.equal blob2.id(), blob2Copy.id()
      assert.deepEqual blob2.attributes(), blob2Copy.attributes()
      assert.deepEqual blob2.links(), blob2Copy.links()
      callback undefined, commitId
  # get commit and check it
  step4 = (commitId, callback) ->
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
      callback err, commit
  # get repo and check it
  step5 = (commit, callback) ->
    reposDao.get "anton$part1", (err, repo) ->
      assert.isUndefined err
      assert.equal "part1", repo.name
      assert.equal "anton", repo.author
      assert.equal "anton", repo.getLink "author"
      assert.equal "part", repo.type
      assert.equal commit.id(), repo.commit
      assert.equal commit.id(), repo.getLink "commit"
      assert.isNull repo.forkedFrom
      assert.isNull repo.getLink "forked_from"
      assert.ok repo.public
      callback err, commit.tree
  # gte blobs from tree
  step6 = (treeId, callback) ->
    treesDao.getBlobs treeId, (err, blobs) ->
      assert.isUndefined err
      assert.equal 2, blobs.length
      blob1Copy = (blob for blob in blobs when blob.id() == blob1.id())[0]
      blob2Copy = (blob for blob in blobs when blob.id() == blob2.id())[0]
      assert.equal blob1.id(), blob1Copy.id()
      assert.deepEqual blob1.attributes(), blob1Copy.attributes()
      assert.deepEqual blob1.links(), blob1Copy.links()
      assert.equal blob2.id(), blob2Copy.id()
      assert.deepEqual blob2.attributes(), blob2Copy.attributes()
      assert.deepEqual blob2.links(), blob2Copy.links()

      callback err, treeId
  # get tree and check it
  step7 = (treeId, callback) ->
    treesDao.get treeId, (err, tree) ->
      assert.isUndefined err
      assert.equal "anton$part1", tree.repo
      assert.equal "anton$part1", tree.getLink "repository"
      assert.equal 2, tree.getLinks("blob").length
      assert.equal blob1.id(), tree.getLinks("blob")[0]
      assert.equal blob2.id(), tree.getLinks("blob")[1]
      callback err, blob1, blob2
  # get blob 1 and check it
  step8 = (blob1, blob2, callback) ->
    blobsDao.get blob1.id(), (err, blob) ->
      assert.isUndefined err
      assert.deepEqual blob1.attributes(), blob.attributes()
      assert.deepEqual blob1.links(), blob.links()
      callback err, blob2
  # get blob 2 and check it
  step9 = (blob2, callback) ->
    blobsDao.get blob2.id(), (err, blob) ->
      assert.isUndefined err
      assert.deepEqual blob2.attributes(), blob.attributes()
      assert.deepEqual blob2.links(), blob.links()
      callback err
  async.waterfall [step1, step2, step3, step4, step5, step6, step7, step8, step9], (err, results) ->
    # clear all temp data
    reposDao.deleteAll()
    commitsDao.deleteAll()
    treesDao.deleteAll()


exports.testFindRepos = ->
  # create repo with different type
  step0a = (callback) ->
    MassiveGit.initRepo "project1", "anton", "project", (err, repo) ->
      assert.isUndefined err
      assert.equal "anton$project1", repo.id()
      callback err
  # create repo with different user
  step0b = (callback) ->
    MassiveGit.initRepo "part1", "andrew", "part", (err, repo) ->
      assert.isUndefined err
      assert.equal "andrew$part1", repo.id()
      callback err
  # create first repo
  step1 = (callback) ->
    MassiveGit.initRepo "part1", "anton", "part", (err, repo) ->
      assert.isUndefined err
      assert.equal "anton$part1", repo.id()
      callback err, repo
  # create second repo
  step2 = (repo1, callback) ->
    MassiveGit.initRepo "part2", "anton", "part", (err, repo) ->
      assert.isUndefined err
      assert.equal "anton$part2", repo.id()
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

exports.testGetUserRepos = ->
  # create user
  step1 = (callback) ->
    MassiveGit.newUser "anton", "anton@circuithub.com", (err, user) ->
      assert.isUndefined err
      callback err, user
  # create first repo
  step2 = (user, callback) ->
    MassiveGit.initRepo "part1", "anton", "part", (err, repo) ->
      assert.isUndefined err
      assert.equal "anton$part1", repo.id()
      callback err, repo
  # create repo with different type
  step3 = (firstRepo, callback) ->
    MassiveGit.initRepo "project1", "anton", "project", (err, repo) ->
      assert.isUndefined err
      assert.equal "anton$project1", repo.id()
      callback err, firstRepo
  # create second repo
  step4 = (repo1, callback) ->
    MassiveGit.initRepo "part2", "anton", "part", (err, repo) ->
      assert.isUndefined err
      assert.equal "anton$part2", repo.id()
      callback err, repo1, repo
  # find repos
  step5 = (repo1, repo2, callback) ->
    MassiveGit.repos "anton", "part", (err, repos) ->
      assert.equal 2, repos.length
      repo1Copy = _.detect repos, (iterator) -> iterator.id() == repo1.id()
      repo2Copy = _.detect repos, (iterator) -> iterator.id() == repo2.id()
      assert.deepEqual repo1.id(), repo1Copy.id()
      assert.deepEqual repo1.attributes(), repo1Copy.attributes()
      assert.deepEqual repo2.id(), repo2Copy.id()
      assert.deepEqual repo2.attributes(), repo2Copy.attributes()

  async.waterfall [step1, step2, step3, step4, step5], (err, results) ->
    # clear all temp data
    reposDao.deleteAll()
    usersDao.deleteAll()

