Dao  = require("./dao").Dao
Repo = require("../objects/repo").Repo

class ReposDao extends Dao

  constructor: ->
    super "repositories"

  populateEntity: (meta, attributes) =>
    # todo (anton) id is not correct at this point
    owner = meta.links[0].key
    if(meta.links[1])
      forkedFrom = meta.links[1].key
    new Repo(meta.key, owner, attributes.type, attributes.public, forkedFrom)

exports.newInstance = -> new ReposDao()

