should     = require "should"
async      = require "async"
reposDao   = require("../../lib/dao/repos.dao").newInstance()
commitsDao = require("../../lib/dao/commits.dao").newInstance()
blobsDao   = require("../../lib/dao/blobs.dao").newInstance()
treesDao   = require("../../lib/dao/trees.dao").newInstance()
usersDao   = require("../../lib/dao/users.dao").newInstance()
MassiveGit = new (require("../../lib/massive.git").MassiveGit)()

helper = exports

helper.createUser = (username, callback) ->
  MassiveGit.newUser username, "some-email@circuithub.com", (err, user) ->
    should.not.exist err
    callback err, user



helper.createUserWithRepo = (username, reponame, repotype, mainCallback) ->
  # create user
  step1 = (callback) ->
    helper.createUser username, callback
  # create repo
  step2 = (user, callback) ->
    MassiveGit.initRepo reponame, username, repotype, (err, repo) ->
      if(err)
        callback err
      else
        repo.id().should.equal username + "$" + reponame
        callback err, repo
  async.waterfall [step1, step2], (err, results) ->
    mainCallback err, results


helper.createUserWithRepos = (username, firstReponame, firstRepotype, secondReponame, secondRepotype, mainCallback) ->
  # create user
  step1 = (callback) ->
    helper.createUser username, callback
  # create first repo
  step2 = (user, callback) ->
    MassiveGit.initRepo firstReponame, username, firstRepotype, (err, repo) ->
      should.not.exist err
      repo.id().should.equal username + "$" + firstReponame
      callback err, repo
  # create second
  step3 = (firstRepo, callback) ->
    MassiveGit.initRepo secondReponame, username, secondRepotype, (err, repo) ->
      should.not.exist err
      repo.id().should.equal username + "$" + secondReponame
      callback err, [firstRepo, repo]

  async.waterfall [step1, step2, step3], (err, results) ->
    mainCallback err, results


helper.deleteAll = ->
  usersDao.deleteAll()
  reposDao.deleteAll()
  commitsDao.deleteAll()
  treesDao.deleteAll()
  blobsDao.deleteAll()

