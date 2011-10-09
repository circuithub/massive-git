Dao = require("./dao").Dao

class ReposDao extends Dao

  constructor: ->
    super "repositories"

  populateEntity: (meta, attributes) =>
    entity = super meta, attributes
    blob = new Repo(attributes.data, meta.links[0].key)
    blob._id = entity._id
    blob


exports.newInstance = -> new ReposDao()

