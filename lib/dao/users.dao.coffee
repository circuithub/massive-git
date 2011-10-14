Dao      = require("./dao").Dao
reposDao = require("./repos.dao").newInstance()
User     = require("../objects/user").User

class UsersDao extends Dao

  constructor: ->
    super "users"

  populateEntity: (meta, attributes) =>
    new User(meta.key, attributes.email, meta.links)

  findAllRepos: (user, type, callback) =>
    @getLinks user, "repositories", type, (err, docs) =>
      if(err)
         callback err
       else
         repos = (reposDao.populateEntity doc.meta, doc.attributes for doc in docs)
         callback undefined, repos


  addRepo: (user, repoId, type, callback) =>
    @get user, (err, user) =>
      if(err)
        callback err
      else
        user.addLink "repositories", repoId, type
        @save user, callback

  removeRepo: (user, repoId, callback) =>


  watchRepo: (user, repoId, type, callback) =>

  unwatchRepo: (user, repoId, callback) =>


  followUser: (user, userToFollow, callback) =>

  unfollowUser: (user, userToUnfollow, callback) =>

exports.newInstance = -> new UsersDao()

