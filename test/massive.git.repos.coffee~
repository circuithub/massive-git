assert     = require "assert"
should     = require "should"
DbTestCase = require("./base/db.test.case").DbTestCase
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
helper     = require "./helper/helper"

exports.testFindRepos = ->
  randomPart1Name = "part1" + Math.floor(1000 * Math.random())
  username = "some-user-name" + Math.floor(1000 * Math.random())
  secondUsername = "another-user-name" + Math.floor(1000 * Math.random())
  # create repo with different type
  # create user
  step1 = (callback) ->
    MassiveGit.newUser username, "anton@circuithub.com", (err, user) ->
      assert.isUndefined err
      callback err, user
  step2 = (user, callback) ->
    MassiveGit.newUser secondUsername, "anton@circuithub.com", (err, user) ->
      assert.isUndefined err
      callback err, user
  step3 = (user, callback) ->
    randomProjectName = "project" + Math.floor(1000 * Math.random())
    MassiveGit.initRepo randomProjectName, username, "project", callback
  # create repo with different user
  step4 = (p1, callback) ->
    MassiveGit.initRepo randomPart1Name, secondUsername, "part", callback
  # create first repo
  step5 = (p2, callback) ->
    MassiveGit.initRepo randomPart1Name, username, "part", callback
  # create second repo
  step6 = (repo1, callback) ->
    randomPart2Name = "part2" + Math.floor(1000 * Math.random())
    MassiveGit.initRepo randomPart2Name, username, "part", (err, repo) ->
      assert.isUndefined err
      callback err, repo1, repo
  # find repos
  step7 = (repo1, repo2, callback) ->
    MassiveGit.getUserRepos username, "part", (err, repos) ->
      console.log "repos", repos, repo1, repo2
      should.not.exist err
      assert.equal 2, repos.length
      repo1Copy = _.detect repos, (iterator) -> iterator.id() == repo1.id()
      repo2Copy = _.detect repos, (iterator) -> iterator.id() == repo2.id()
      assert.deepEqual repo1.id(), repo1Copy.id()
      assert.deepEqual repo1.attributes(), repo1Copy.attributes()
      assert.deepEqual repo1.links(), repo1Copy.links()
      assert.deepEqual repo2.id(), repo2Copy.id()
      assert.deepEqual repo2.attributes(), repo2Copy.attributes()
      assert.deepEqual repo2.links(), repo2Copy.links()

  testCase = new DbTestCase step1, step2, step3, step4, step5, step6, step7
  testCase.run()

