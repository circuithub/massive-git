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
  async.waterfall [step0, step1, step2, step3, step4, step5, step6, step7, step8, step9], (err, results) ->
    # clear all temp data
    usersDao.deleteAll()
    reposDao.deleteAll()
    commitsDao.deleteAll()
    treesDao.deleteAll()


exports.testCommitUpdate = ->
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
  # commit 1 file
  step2 = (repo, callback) ->
    entries = [new TreeEntry("datasheet.json", blob1)]
    MassiveGit.commit entries, repo.id(), "anton", "first commit", undefined, (err, commitId) ->
      assert.isUndefined err
      callback err, commitId
  # get entries from commit
  step3 = (commitId, callback) ->
    MassiveGit.fetchRootEntriesForCommit commitId, (err, entries) ->
      assert.isUndefined err
      assert.equal 1, entries.length
      blob1Copy = entries[0].entry
      assert.equal blob1.id(), blob1Copy.id()
      assert.deepEqual blob1.attributes(), blob1Copy.attributes()
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

      callback err, commit
  # get blobs from tree
  step5 = (commit, callback) ->
    treesDao.getBlobs commit.tree, (err, blobs) ->
      assert.isUndefined err
      assert.equal 1, blobs.length
      blob1Copy = (blob for blob in blobs when blob.id() == blob1.id())[0]
      assert.equal blob1.id(), blob1Copy.id()
      assert.deepEqual blob1.attributes(), blob1Copy.attributes()
      assert.deepEqual blob1.links(), blob1Copy.links()
      callback err, commit
  # get tree and check it
  step6 = (commit, callback) ->
    treesDao.get commit.tree, (err, tree) ->
      console.log "TREE ID", commit.id(), commit.tree
      assert.isUndefined err
      assert.equal "anton$part1", tree.repo
      assert.equal "anton$part1", tree.getLink "repository"
      assert.equal 1, tree.getLinks("blob").length
      assert.equal blob1.id(), tree.getLinks("blob")[0]
      callback err, blob1
  # commit new blob
  step7 = (commit, callback) ->
    entries = [new TreeEntry("symbol.json", blob2)]
    MassiveGit.addToIndex entries, "anton$part1", "andrew", "update", (err, commitId) ->
      assert.isUndefined err
      callback err, commitId
  # get commit and check it
  step8 = (commitId, callback) ->
    commitsDao.get commitId, (err, commit) ->
      assert.isUndefined err
      assert.equal "andrew", commit.author
      assert.equal "andrew", commit.getLink "author"
      assert.equal "andrew", commit.committer
      assert.equal "andrew", commit.getLink "committer"
      assert.equal "update", commit.message
      assert.equal "anton$part1", commit.repo
      assert.equal "anton$part1", commit.getLink "repository"
      assert.isDefined commit.authoredDate
      assert.isDefined commit.commitedDate
      assert.isDefined commit.tree

      callback err, commit
  # get blobs from tree
  step9 = (commit, callback) ->
    treesDao.getBlobs commit.tree, (err, blobs) ->
      assert.isUndefined err
      assert.equal 2, blobs.length
      callback err, commit

  async.waterfall [step0, step1, step2, step3, step4, step5, step6, step7, step8, step9], (err, results) ->
    # clear all temp data
    usersDao.deleteAll()
    reposDao.deleteAll()
    commitsDao.deleteAll()
    treesDao.deleteAll()

