Tree       = require("../objects/tree").Tree
blobsDao = require("./blobs.dao").newInstance()
ObjectsDao = require("./objects.dao").ObjectsDao

class TreesDao extends ObjectsDao

  populateEntity: (meta, attributes) =>
    repository = @getLink meta.links, "repository"
    new Tree(attributes.entries, repository, meta.key)

  getBlobs: (treeId, callback) =>
    map = (value) ->
      row = value.values[0]
      entity = {}
      entity.attributes = JSON.parse(row.data)
      metadata = row.metadata
      userMeta = metadata["X-Riak-Meta"]
      entity.meta = {}
      entity.meta.key = value.key
      linksArray = metadata["Links"]
      links =[]
      for link in linksArray
        links.push {bucket : link[0], key : link[1], tag : link[2] }
      entity.meta.links = links
      [entity]

    @getLinks treeId, @bucket, "blob", map, (err, docs) =>
      if(err)
         callback err
       else
         blobs = (blobsDao.populateEntity doc.meta, doc.attributes for doc in docs)
         callback undefined, blobs

exports.newInstance = -> new TreesDao()

