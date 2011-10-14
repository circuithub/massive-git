Tree       = require("../objects/tree").Tree
blobsDao = require("./blobs.dao").newInstance()
ObjectsDao = require("./objects.dao").ObjectsDao

class TreesDao extends ObjectsDao

  populateEntity: (meta, attributes) =>
    repository = @getLink meta.links, "repository"
    new Tree(attributes.entries, repository, meta.key)

  getBlobs: (treeId, callback) =>
    @getLinks treeId, @bucket, "blob",(err, docs) =>
      if(err)
         callback err
       else
         blobs = (blobsDao.populateEntity doc.meta, doc.attributes for doc in docs)
         callback undefined, blobs

exports.newInstance = -> new TreesDao()

