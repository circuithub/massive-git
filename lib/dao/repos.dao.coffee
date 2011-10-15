Dao  = require("./dao").Dao
Repo = require("../objects/repo").Repo

class ReposDao extends Dao

  constructor: (log)->
    super "repositories", log

  populateEntity: (meta, attributes) =>
    author = @getLink meta.links, "author"
    forkedFrom = @getLink meta.links, "forked_from"
    commit = @getLink meta.links, "commit"
    new Repo(attributes.name, author, attributes.type, attributes.public, commit, forkedFrom)


exports.newInstance = (log) -> new ReposDao(log)

