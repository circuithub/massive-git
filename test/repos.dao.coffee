should   = require "should"
TestCase = require("./base/test.case").TestCase
reposDao = require("../lib/dao/repos.dao").newInstance()
Repo     = require("../lib/objects/repo").Repo

exports.testSaveRepo = (beforeExit) ->
  # create new repo and save it
  step1 = (callback) ->
    repo = new Repo("project1", "anton", "project")
    reposDao.save repo, (err, data) ->
      should.not.exist err
      should.exist data
      callback err, repo
  # get repo from db by id and compare with initial
  step2 = (repo, callback) ->
    reposDao.get repo.id(), (err, repoFromDao) ->
      should.not.exist err
      repoFromDao.equals(repo).should.be.ok
      callback err
  testCase = new TestCase [step1, step2]
  testCase.tearDown = -> reposDao.deleteAll()
  testCase.run()
  beforeExit () -> testCase.tearDown()

exports.testSearchRepos = (beforeExit) ->
  randomFirstProjectName = "first-project" + Math.floor(1000 * Math.random())
  randomSecondProjectName = "second-project" + Math.floor(1000 * Math.random())
  # create first repo and save it
  step1 = (callback) ->
    repo = new Repo(randomFirstProjectName, "anton", "project")
    reposDao.save repo, (err, data) ->
      should.not.exist err
      should.exist data
      callback err, repo
  # create second repo for the same user.
  step2 = (repo, callback) ->
    repo = new Repo(randomSecondProjectName, "anton", "project")
    reposDao.save repo, (err, data) ->
      should.not.exist err
      should.exist data
      callback err, repo
  # create repo for second user
  step3 = (repo, callback) ->
    repo = new Repo(randomFirstProjectName, "andrew", "project")
    reposDao.save repo, (err, data) ->
      should.not.exist err
      should.exist data
      callback err, repo
  # search repos by name
  step4 = (repo, callback) ->
     reposDao.search randomFirstProjectName, undefined, (err, repos) ->
       should.not.exist err
       repos.should.have.length 2
       callback err, repos
  # search repos by fake name
  step5 = (repos, callback) ->
     reposDao.search "fake-repo-name", undefined, (err, repos) ->
       should.not.exist err
       repos.should.have.length 0
       callback err, repos
  # search repos by first user
  step6 = (repos, callback) ->
     reposDao.search undefined, "anton", (err, repos) ->
       should.not.exist err
       repos.should.have.length 2
       callback err, repos
  # search repos by second user
  step7 = (repos, callback) ->
     reposDao.search undefined, "andrew", (err, repos) ->
       should.not.exist err
       repos.should.have.length 1

  testCase = new TestCase [step1, step2, step3, step4, step5, step6, step7]
  testCase.tearDown = -> reposDao.deleteAll()
  testCase.run()
  beforeExit () -> testCase.tearDown()

