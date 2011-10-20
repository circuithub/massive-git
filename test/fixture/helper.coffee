should     = require "should"
reposDao   = require("../../lib/dao/repos.dao").newInstance()
commitsDao = require("../../lib/dao/commits.dao").newInstance()
blobsDao   = require("../../lib/dao/blobs.dao").newInstance()
treesDao   = require("../../lib/dao/trees.dao").newInstance()
usersDao   = require("../../lib/dao/users.dao").newInstance()

helper = exports

helper.createUserWithRepo = (username, reponame, repotype, callback) ->
  # create user
  step0 = (callback) ->
    MassiveGit.newUser username, "some-email@circuithub.com", (err, user) ->
      should.not.exist err
      callback err, user
  # create repo
  step1 = (user, callback) ->
    MassiveGit.initRepo reponame, username, repotype, (err, repo) ->
      should.not.exist err
      repo.id().should.equal username + "$" + reponame
      callback err, repo

helper.deleteAll = ->
  usersDao.deleteAll()
  reposDao.deleteAll()
  commitsDao.deleteAll()
  treesDao.deleteAll()
  blobsDao.deleteAll()

