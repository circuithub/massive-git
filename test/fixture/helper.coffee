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
    console.log "sad", err, user
    should.not.exist err
    callback err, user

helper.createUserWithRepo = (username, reponame, repotype, mainCallback) ->
  # create user
  step1 = (callback) ->
    console.log username, helper.createUser
    helper.createUser username, callback
  # create repo
  step2 = (user, callback) ->
    MassiveGit.initRepo reponame, username, repotype, (err, repo) ->
      should.not.exist err
      repo.id().should.equal username + "$" + reponame
      callback err, repo
  async.waterfall [step1, step2], (err, results) ->
    mainCallback err, results


helper.deleteAll = ->
  usersDao.deleteAll()
  reposDao.deleteAll()
  commitsDao.deleteAll()
  treesDao.deleteAll()
  blobsDao.deleteAll()

