_        = require "underscore"
Dao      = require("./dao").Dao
reposDao = require("./repos.dao").newInstance()
blobsDao = require("./blobs.dao").newInstance()
User     = require("../objects/user").User

class UsersDao extends Dao

  constructor: (log) ->
    super "users", log

  populateEntity: (meta, attributes) =>
    new User(meta.key, attributes.email, meta.links)

  findAllRepos: (user, type, callback) =>
    @walk user, [["repositories", type]], (err, docs) =>
      if(err)
         callback err
      else
        console.log "retrieved repos", docs if @log
        repos = (reposDao.populateEntity doc.meta, doc.attributes for doc in docs when doc.meta?)
        callback undefined, repos

  # return map:
  fetchAllRepos: (user, type, callback) =>
    @walk user, [["repositories", type, true],["objects", "commit", true],["objects", "tree", true],["objects", "blob"]], (err, docs) =>
      if(err)
         callback err
      else
        console.log "fetched repos", docs if @log
        reposEnrties = (blobsDao.populateEntity doc.meta, doc.attributes for doc in docs when doc.meta?)
        groupedEntries = _.groupBy reposEnrties, (entry) -> entry.repo
        console.log "grouped repos", groupedEntries if @log
        callback undefined, groupedEntries

  addRepo: (user, repoId, type, callback) =>
    @get user, (err, user) =>
      if(err)
        callback err
      else
        user.addLink "repositories", repoId, type
        @save user, callback

  removeRepo: (user, repoId, type, callback) =>
    @get user, (err, user) =>
      if(err)
        callback err
      else
        user.removeLink "repositories", repoId, type
        @save user, callback


  watchRepo: (user, repoId, type, callback) =>

  unwatchRepo: (user, repoId, callback) =>


  followUser: (user, userToFollow, callback) =>

  unfollowUser: (user, userToUnfollow, callback) =>

exports.newInstance = (log) -> new UsersDao(log)

