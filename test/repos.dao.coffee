should   = require "should"
reposDao = require("../lib/dao/repos.dao").newInstance()
Repo     = require("../lib/objects/repo").Repo

describe "ReposDao", ->
  describe "#get() after #save()", ->
    repo = new Repo("project1", "anton", "project")  
    before (done) ->
      reposDao.save repo, done
    it "return matching object", (done) ->
      reposDao.get repo.id(), (err, repoFromDao) ->
        should.not.exist err
        repoFromDao.equals(repo).should.be.ok
        done err
    after (done) ->
      reposDao.remove repo.id(), done

