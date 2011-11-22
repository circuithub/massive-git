Tree       = require("../objects/tree").Tree
blobsDao   = require("./blobs.dao").newInstance()
ObjectsDao = require("./objects.dao").ObjectsDao

class TreesDao extends ObjectsDao

  constructor: (log)-> super log

  populateEntity: (meta, attributes) =>
    if attributes?
      new Tree(attributes.entries, @getRepository(meta.links), meta.key)

  getBlobs: (treeId, callback) =>
    @walk treeId, [[@bucket, "blob"]], (err, docs) =>
      if err
         console.log "Cannot get blobs for tree", treeId, err if @log?
         callback err
       else
         blobs = (blobsDao.populateEntity doc.meta, doc.attributes for doc in docs when doc? and doc.attributes?)
         callback undefined, blobs

exports.newInstance = (log) -> new TreesDao(log)

