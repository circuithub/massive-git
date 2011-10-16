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

exports.testDeleteRepo = ->
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
  # create second repo
  step3 = (repo1, callback) ->
    MassiveGit.initRepo "part2", "anton", "part", (err, repo) ->
      assert.isUndefined err
      assert.equal "anton$part2", repo.id()
      callback err, repo1, repo
  # find repos
  step4 = (repo1, repo2, callback) ->
    MassiveGit.repos "anton", "part", (err, repos) ->
      assert.equal 2, repos.length
      repo1Copy = _.detect repos, (iterator) -> iterator.id() == repo1.id()
      repo2Copy = _.detect repos, (iterator) -> iterator.id() == repo2.id()
      assert.deepEqual repo1.id(), repo1Copy.id()
      assert.deepEqual repo1.attributes(), repo1Copy.attributes()
      assert.deepEqual repo2.id(), repo2Copy.id()
      assert.deepEqual repo2.attributes(), repo2Copy.attributes()
      callback err, repo1, repo2
  # remove repo
  step5 = (repo1, repo2, callback) ->
    MassiveGit.deleteRepo repo1.id(),"anton", "part", (err, user) ->
      console.log user, user.links()
      assert.isUndefined err
      assert.equal 1, user.links().length
      callback err, repo2
  # find repos
  step6 = (repo2, callback) ->
    MassiveGit.repos "anton", "part", (err, repos) ->
      assert.equal 1, repos.length
      repo2Copy = repos[0]
      assert.deepEqual repo2.id(), repo2Copy.id()
      assert.deepEqual repo2.attributes(), repo2Copy.attributes()
  async.waterfall [step1, step2, step3, step4, step5, step6], (err, results) ->
    # clear all temp data
    reposDao.deleteAll()
    usersDao.deleteAll()

