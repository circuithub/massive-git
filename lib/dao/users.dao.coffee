Dao  = require("./dao").Dao
User = require("../objects/user").User

class UsersDao extends Dao

  constructor: ->
    super "users"

  populateEntity: (meta, attributes) =>
    # todo (anton) parse links.
    new User(meta.key, owner, attributes.email, attributes.date)

exports.newInstance = -> new ReposDao()

