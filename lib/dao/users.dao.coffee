Dao  = require("./dao").Dao
User = require("../objects/user").User

class UsersDao extends Dao

  constructor: ->
    super "users"

  populateEntity: (meta, attributes) =>
    # todo (anton) parse links.
    new User(meta.key, attributes.email, attributes.password, attributes.date)

  addRepo: (user, repoId, callback) =>

  removeRepo: (user, repoId, callback) =>


  forkRepo: (user, repoId, callback) =>

  unforkRepo: (user, repoId, callback) =>


  watchRepo: (user, repoId, callback) =>

  unwatchRepo: (user, repoId, callback) =>

exports.newInstance = -> new UsersDao()

