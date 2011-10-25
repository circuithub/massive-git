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
helper     = require "./fixture/helper"

exports.testFindRepos = ->
  randomPart1Name = "part1" + Math.floor(1000 * Math.random())
  # create repo with different type
  step0a = (callback) ->
    randomProjectName = "project" + Math.floor(1000 * Math.random())
    MassiveGit.initRepo randomProjectName, "anton", "project", callback
  # create repo with different user
  step0b = (p1, callback) ->
    MassiveGit.initRepo randomPart1Name, "andrew", "part", callback
  # create first repo
  step1 = (p2, callback) ->
    MassiveGit.initRepo randomPart1Name, "anton", "part", callback
  # create second repo
  step2 = (repo1, callback) ->
    randomPart2Name = "part2" + Math.floor(1000 * Math.random())
    MassiveGit.initRepo randomPart2Name, "anton", "part", (err, repo) ->
      assert.isUndefined err
      callback err, repo1, repo
  # find repos
  step3 = (repo1, repo2, callback) ->
    MassiveGit.repos "anton", "part", (err, repos) ->
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

  testCase = new DbTestCase [step0a, step0b, step1, step2, step3]
  testCase.run()

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

  testCase = new DbTestCase [step1, step2, step3, step4, step5]
  testCase.run()


exports.testDeleteRepo = ->
  # create user with two repos
  step1 = (callback) ->
    helper.createUserWithRepos "anton", "part1", "part", "part2", "part", callback
  # find repos
  step2 = (results, callback) ->
    repo1 = results[0]
    repo2 = results[1]
    MassiveGit.repos "anton", "part", (err, repos) ->
      repos.should.have.length 2
      repo1Copy = _.detect repos, (iterator) -> iterator.id() == repo1.id()
      repo2Copy = _.detect repos, (iterator) -> iterator.id() == repo2.id()
      repo1Copy.equals(repo1).should.be.ok
      repo2Copy.equals(repo2).should.be.ok
      callback err, repo1, repo2
  # remove repo
  step3 = (repo1, repo2, callback) ->
    MassiveGit.deleteRepo repo1.id(),"anton", "part", (err, user) ->
      should.not.exist err
      user.links().should.have.length 1
      callback err, repo2
  # find repos
  step4 = (repo2, callback) ->
    MassiveGit.repos "anton", "part", (err, repos) ->
      repos.should.have.length 1
      repo2Copy = repos[0]
      repo2Copy.equals(repo2).should.be.ok

  testCase = new DbTestCase [step1, step2, step3, step4]
  testCase.run()

