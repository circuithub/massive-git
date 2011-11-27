Tree       = require("../objects/tree").Tree
blobsDao   = require("./blobs.dao").newInstance()
ObjectsDao = require("./objects.dao").ObjectsDao

class TreesDao extends ObjectsDao

  populateEntity: (meta, attributes) =>
    repo = @getRepository(meta.links)
    new Tree(attributes.entries, repo, meta.key) if attributes?

  getBlobs: (treeId, callback) =>
    @walk treeId, [[@bucket, "blob"]], (err, docs) =>
      if err
         callback err
       else
         blobs = (blobsDao.populateEntity doc.meta, doc.attributes for doc in docs when doc? and doc.attributes?)
         callback undefined, blobs

exports.newInstance = (log) -> new TreesDao(log)

