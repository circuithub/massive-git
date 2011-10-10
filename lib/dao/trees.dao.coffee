Tree       = require("../objects/tree").Tree
ObjectsDao = require("./objects.dao").ObjectsDao

class TreesDao extends ObjectsDao

  populateEntity: (meta, attributes) =>
    repository = @getLink meta.links, "repository"
    new Tree(attributes.entries, repository, meta.key)

exports.newInstance = -> new TreesDao()

