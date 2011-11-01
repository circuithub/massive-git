riak  = require "riak-js"
utils = require "../objects/utils"

# Dao
# -----------
# Base class for all Dao classes. Some common methods should be implemented here.
Dao = exports.Dao = class Dao

  constructor: (@bucket, @log = true) ->
    @db = riak.getClient({debug: @log})

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
   meta = {links: entity.links(), index: entity.index()}
   @db.save @bucket, entity.id(), entity.attributes(), meta, (err, emptyEntity, meta) =>
     if(err)
       callback err
     else
       console.log "entity was saved in bucket", @bucket, "with id =", entity.id() if @log
       callback undefined, entity

  # Remove entity by `id`.
  remove: (id, callback) => @db.remove @bucket, id, callback

  # Remove all entities from `bucket`. TODO (anton) rename to removeAll
  deleteAll: =>
    @db.getAll @bucket, (err, objects) =>
      if(!err)
        objects.forEach (object) =>
          console.log "removing entity from bucket", @bucket, "with id =", object.meta.key if @log
          @db.remove @bucket, object.meta.key

  # Checks if such key exists in database. Callback takes 2 parameters: `err` and `exists` boolean parameter
  exists: (id, callback) => @db.exists @bucket, id, callback

  # Get all links from entity to some `bucket` under specified `tag`.
  walk: (id, spec, callback) =>
    linkPhases = spec.map (unit) ->
      bucket: unit[0] or '_', tag: unit[1] or '_', keep: unit[2]?
    @db
      .add({bucket: @bucket, key_filters: [["eq", id]]})
      .link(linkPhases)
      .map(@_map)
      .run(callback)

  links: (id, spec, callback) => @db.links @bucket, id, spec, callback

  # Method for building GitEntity.
  populateEntity: (meta, attributes) ->

  getLink: (links, tag) -> utils.getLink links, tag

  # Default map functions
  _map: (value) ->
    row = value.values[0]
    entity = {}
    entity.attributes = JSON.parse(row.data)
    metadata = row.metadata
    entity.lastModifiedParsed = Date.parse(metadata["X-Riak-Last-Modified"])
    userMeta = metadata["X-Riak-Meta"]
    entity.meta = {}
    entity.meta.key = value.key
    linksArray = metadata["Links"]
    links = ({bucket: link[0], key: link[1], tag: link[2]} for link in linksArray)
    entity.meta.links = links
    [entity]

