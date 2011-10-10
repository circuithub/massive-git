riak      = require "riak-js"

# Dao
# -----------
# Base class for all Dao classes. Some common methods should be implemented here.
class Dao

  constructor: (@bucket, @log = true) ->
    @db = riak.getClient({ debug : true })

  # Get entity by `id`. Callback takes `error` and `entity` object.
  get: (id, callback) =>
   console.log "getting entity with id =", id, "from bucket =", @bucket if @log
   @db.get @bucket, id, (err, attributes, meta) =>
      if(err)
        callback err
      else
        callback undefined, @populateEntity(meta, attributes)

  # Save entity.
  save: (entity, callback) =>
   console.log "saving entity with id =", entity.id(), "into bucket =", @bucket if @log
   meta = { links : entity.links() }
   @db.save @bucket, entity.id(), entity.attributes(), meta, (err, emptyEntity, meta) =>
     if(err)
       callback err
     else
       console.log "entity was saved in bucket", @bucket, "with id =", entity.id() if @log
       callback undefined, @populateEntity(meta, entity.attributes()), meta

  # Delete entity by `id`.
  delete: (id, callback) ->
    @db.remove @bucket, id, callback

  # Delete all entities from `bucket`.
  deleteAll: =>
    @db.getAll @bucket, (err, objects) =>
      if(!err)
        objects.forEach (object) =>
          console.log "removing entity from bucket", @bucket, "with id =", object.meta.key if @log
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

  # Method for building GitEntity.
  populateEntity: (meta, attributes) =>

exports.Dao = Dao

