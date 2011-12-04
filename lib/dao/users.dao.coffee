_          = require "underscore"
Dao        = require("riak-entity").Dao
reposDao   = require("./repos.dao").newInstance()
blobsDao   = require("./blobs.dao").newInstance()
commitsDao = require("./commits.dao").newInstance()
treesDao   = require("./trees.dao").newInstance()
User       = require("../objects/user").User

class UsersDao extends Dao

  constructor: (log) -> super "users", log

  populateEntity: (meta, attributes) -> 
    new User(meta.key, attributes.email, meta.links) if attributes?

  fetchAllRepos: (username, callback) =>
    @get username, (err, user) =>
      console.log "user", user.links()
      if err
        callback err
      else
        callback undefined, user.getLinks "repositories"

  addRepo: (user, repoId, type, callback) =>
    @get user, (err, user) =>
      if err
        callback err
      else
        user.addLink "repositories", repoId, type
        @save user, callback

  removeRepo: (user, repoId, callback) =>
    @get user, (err, user) =>
      if err
        callback err
      else
        user.removeLink "repositories", repoId
        @save user, callback


  watchRepo: (user, repoId, type, callback) =>

  unwatchRepo: (user, repoId, callback) =>


  followUser: (user, userToFollow, callback) =>

  unfollowUser: (user, userToUnfollow, callback) =>

exports.newInstance = (log) -> new UsersDao(log)
