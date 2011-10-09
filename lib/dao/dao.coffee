riak = require "riak-js"

# Dao
# -----------
# Base class for all Dao classes. Some common methods should be implemented here.
class Dao

  constructor: (@bucket) ->
    @db = riak.getClient({ debug : true })

  # Create new instance of the entity. Provide `id`, `attributes` and optionally `links`.
  create: (id, attributes, links = [], callback) =>
    console.log "creating new entity with id =", id, "in bucket =", @bucket
    meta = @_prepareMetaForNewEntity links
    @db.save @bucket, id, attributes, meta, (err, emptyEntity, meta) =>
      if(err)
        callback err
      else
        console.log "new entity was saved in bucket", @bucket, "with id =", id
        callback undefined, @_populateEntity meta, attributes

  # Get entity by `id`. Callback takes `error` and `entity` object.
  get: (id, callback) =>
   console.log "getting entity with id =", id, "from bucket =", @bucket
   @db.get @bucket, id, (err, attributes, meta) =>
      if(err)
        callback err
      else
        callback undefined, @_populateEntity(meta, attributes)

  # Save entity.
  save: (entity, callback) =>
   console.log "saving entity with id =", entity.id, "into bucket =", @bucket
   entity.meta.modified = new Date().getTime()
   @db.save @bucket, entity.id, entity.attributes, entity.meta, (err, emptyEntity, meta) =>
     if(err)
       callback err
     else
       callback undefined, @_populateEntity(meta, entity.attributes), meta

  # Delete entity by `id`.
  delete: (id, callback) ->
    @db.remove @bucket, id, callback

  # Delete all entities from `bucket`.
  deleteAll: =>
    @db.getAll @bucket, (err, objects) =>
      if(!err)
        objects.forEach (object) =>
          @db.remove @bucket, object.meta.key

  # Checks if such key exists in database.
  exists : (id, callback) =>
    @db.exists @bucket, id, callback

  # Get all links from entity to some `bucket` under specified `tag`.
  getLinks: (id, linkBucket, tag, callback) =>
    @db
      .add({ bucket : @bucket, key_filters : [["matches", id]] })
      .link({ bucket : linkBucket, tag : tag })
      .map (value, keyData) ->
        data = JSON.parse(value.values[0].data)
        data.id = value.key
        [data]
      .run(callback)

  # Private method for building entity.
  _populateEntity: (meta, attributes) =>
    entity =
      id         : meta.key
      attributes : attributes
      meta       :
        vclock   : meta.vclock
        links    : meta.links
        created  : meta.usermeta.created
        modified : meta.usermeta.modified
    entity

  # Private method for populating metadata for newly created entity.
  _prepareMetaForNewEntity: (links) =>
    time = new Date().getTime()
    # todo (anton) remove this version property from this class
    { links : links, created : time, modified : time }

exports.Dao = Dao

