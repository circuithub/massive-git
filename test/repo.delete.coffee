should     = require "should"
DbTestCase = require("./base/db.test.case").DbTestCase
MassiveGit = new (require("../lib/massive.git").MassiveGit)()
helper     = require "./helper/helper"

exports.testDeleteRepo = (beforeExit) ->
  randomRepo1Name = "part-one-for-delete" + Math.floor(1000 * Math.random())
  randomRepo2Name = "part-second-for-delete" + Math.floor(1000 * Math.random())
  # create user with two repos
  step1 = (callback) ->
    helper.createUserWithRepos "anton", randomRepo1Name, "part", randomRepo2Name, "part", callback
  # find repos
  step2 = (results, callback) ->
    repo1 = results[0]
    repo2 = results[1]
    MassiveGit.getUserRepos "anton", "part", (err, repos) ->
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
    MassiveGit.getUserRepos "anton", "part", (err, repos) ->
      repos.should.have.length 1
      repo2Copy = repos[0]
      repo2Copy.equals(repo2).should.be.ok

  testCase = new DbTestCase [step1, step2, step3, step4]
  testCase.run()

