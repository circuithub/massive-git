Dao = require("./dao").Dao

class ObjectsDao extends Dao

  constructor: (log) ->
    super "objects", log

  populateEntity: (meta, attributes) =>
    super meta, attributes

  # Get link to repository. Can be `null`.
  getRepository: (links) =>  @getLink links, "repository"

exports.ObjectsDao = ObjectsDao

