Blob       = require("../objects/blob").Blob
ObjectsDao = require("./objects.dao").ObjectsDao

class BlobsDao extends ObjectsDao

  constructor: (log)-> super log

  populateEntity: (meta, attributes) =>
    attributes = JSON.parse(attributes) if meta.contentType == "application/json"
    new Blob(attributes, @getRepository(meta.links), meta.key, meta.contentType)

exports.newInstance = (log) -> new BlobsDao(log)

