should     = require "should"
commitsDao = require("../lib/dao/commits.dao").newInstance()
Commit     = require("../lib/objects/commit").Commit

describe "CommitsDao", ->
  describe "#get() after #save()", ->
    authoredDate = new Date().getTime()
    commitedDate = new Date().getTime()
    commit = new Commit("tree-id", "parent-id", "anton", "anton@circuithub.com", authoredDate, "andrew", "andrew@circuithub.com", commitedDate, "initial commit", "anton$project1")
    before (done) ->
      commitsDao.save commit, (err, data) ->
        should.not.exist err
        should.exist data
        done err
    it "return matching object", (done) ->
      commitsDao.get commit.id(), (err, commitFromDao) ->
        should.not.exist err
        commitFromDao.equals(commit).should.be.ok
        done err
    after (done) -> 
      commitsDao.deleteAll()
      done()

