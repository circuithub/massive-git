Dao      = require("./dao").Dao
reposDao = require("./repos.dao").newInstance()
User     = require("../objects/user").User

class UsersDao extends Dao

  constructor: (log) ->
    super "users", log

  populateEntity: (meta, attributes) =>
    new User(meta.key, attributes.email, meta.links)

  findAllRepos: (user, type, callback) =>
    @getLinks user, "repositories", type, (err, docs) =>
      console.log "getting repositories", err,docs
      if(err)
         callback err
      else
        console.log "getting repositories", docs
        repos = (reposDao.populateEntity doc.meta, doc.attributes for doc in docs when doc.meta?)
        callback undefined, repos


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

