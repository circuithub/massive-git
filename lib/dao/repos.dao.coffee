Dao = require("./dao").Dao

class ReposDao extends Dao

  constructor: ->
    super "repositories"

  populateEntity: (meta, attributes) =>
    super meta, attributes

exports.newInstance = -> new ReposDao()

