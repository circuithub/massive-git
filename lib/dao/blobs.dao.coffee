Blob       = require("../objects/blob").Blob
ObjectsDao = require("./objects.dao").ObjectsDao

class BlobsDao extends ObjectsDao

  populateEntity: (meta, attributes) =>
    new Blob().build(meta, attributes)

exports.newInstance = -> new BlobsDao()

