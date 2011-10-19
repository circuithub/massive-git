Tree       = require("../objects/tree").Tree
blobsDao   = require("./blobs.dao").newInstance()
ObjectsDao = require("./objects.dao").ObjectsDao

class TreesDao extends ObjectsDao

  constructor: (log)->
    super log

  populateEntity: (meta, attributes) =>
    repository = @getLink meta.links, "repository"
    new Tree(attributes.entries, repository, meta.key)

  getBlobs: (treeId, callback) =>
    @walk treeId, [[@bucket, "blob"]], (err, docs) =>
      if(err)
         callback err
       else
         blobs = (blobsDao.populateEntity doc.meta, doc.attributes for doc in docs)
         callback undefined, blobs

exports.newInstance = (log) -> new TreesDao(log)

