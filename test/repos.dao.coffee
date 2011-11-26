should   = require "should"
reposDao = require("../lib/dao/repos.dao").newInstance()
Repo     = require("../lib/objects/repo").Repo


describe "saved repo", ->
  repo = new Repo("project1", "anton", "project")  
  before (done) ->
    reposDao.save repo, (err, data) ->
      done err
  it "should be retrieved by id", (done) ->
    reposDao.get repo.id(), (err, repoFromDao) ->
      should.not.exist err
      repoFromDao.equals(repo).should.be.ok
      done err
  after (done) ->
    reposDao.remove repo.id(), done

