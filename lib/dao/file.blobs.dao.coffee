riak     = require "riak-js"
utils    = require "../objects/utils"
FileBlob = require("../objects/file.blob").FileBlob

#http://localhost:8098//riak/luwak_tld?keys=true
#http://markmail.org/message/46cvg3pxrd6veenh
# FileBlobsDao
# -----------
# Dao class for `FileBlob`s.
class FileBlobsDao

  constructor: (@log = false) ->
    @db = riak.getClient({debug: @log})

  populateEntity: (meta, buffer) =>
    new FileBlob(attributes.data, @getRepository(meta.links), meta.key)


  save: (fileBlob, callback) =>
    @db.saveLarge fileBlob.id(), fileBlob.data, {author: "x"},(err, data) =>
      console.log "done", err, data

  get: (id, callback) =>
    @db.getLarge id, (err, buffer, meta) =>
      if(err)
        callback err
       else
         callback undefined, populateEntity(meta, buffer)

exports.newInstance = (log) -> new FileBlobsDao(log)

