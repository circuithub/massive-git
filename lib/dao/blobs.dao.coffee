Blob       = require("../objects/blob").Blob
ObjectsDao = require("./objects.dao").ObjectsDao

class BlobsDao extends ObjectsDao

  constructor: (log)-> super log

  populateEntity: (meta, attributes) =>
    if attributes?
      new Blob(attributes, @getRepository(meta.links), meta.key, meta.contentType)

exports.newInstance = (log) -> new BlobsDao(log)
