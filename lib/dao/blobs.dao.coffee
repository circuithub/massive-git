Blob       = require("../objects/blob").Blob
ObjectsDao = require("./objects.dao").ObjectsDao

class BlobsDao extends ObjectsDao

  populateEntity: (meta, attributes) =>
    new Blob(attributes.data, meta.links[0].key, meta.key)

exports.newInstance = -> new BlobsDao()

