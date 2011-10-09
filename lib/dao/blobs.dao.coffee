Blob       = require("../objects/blob").Blob
ObjectsDao = require("./objects.dao").ObjectsDao

class BlobsDao extends ObjectsDao

  populateEntity: (meta, attributes) =>
    entity = super meta, attributes
    blob = new Blob()
    blob._id = entity._id
    blob.type = attributes.type
    blob.data = attributes.data
    blob.repo = meta.links[0].key
    blob

exports.newInstance = -> new BlobsDao()

