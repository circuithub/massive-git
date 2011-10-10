Blob       = require("../objects/blob").Blob
ObjectsDao = require("./objects.dao").ObjectsDao

class BlobsDao extends ObjectsDao

  populateEntity: (meta, attributes) =>
    new Blob(attributes.data, @getRepository(meta.links), meta.key)

exports.newInstance = -> new BlobsDao()

