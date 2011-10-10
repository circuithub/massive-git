Dao = require("./dao").Dao

class ObjectsDao extends Dao

  constructor: ->
    super "objects"

  populateEntity: (meta, attributes) =>
    super meta, attributes

  # Get link to repository. Can be `null`.
  getRepository: (links) =>
    @getLink links, "repository"

exports.ObjectsDao = ObjectsDao

