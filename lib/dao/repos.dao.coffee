Dao  = require("./dao").Dao
Repo = require("../objects/repo").Repo

class ReposDao extends Dao

  constructor: ->
    super "repositories"

  populateEntity: (meta, attributes) =>
    owner = @getLink meta.links, "owner"
    forkedFrom = @getLink meta.links, "forked_from"
    commit = @getLink meta.links, "commit"
    new Repo(attributes.name, owner, attributes.type, attributes.public, commit, forkedFrom)

exports.newInstance = -> new ReposDao()

