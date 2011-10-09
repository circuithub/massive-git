Dao = require("./dao").Dao

class ObjectsDao extends Dao

  constructor: ->
    super "objects"

  populateEntity: (meta, attributes) =>
    super meta, attributes

exports.ObjectsDao = ObjectsDao

