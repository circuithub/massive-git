fs    = require "fs"
riak  = require "riak-js"
utils = require "../objects/utils"

#http://localhost:8098//riak/luwak_tld?keys=true
#http://markmail.org/message/46cvg3pxrd6veenh
# FilesDao
# -----------
# Base class for all Dao classes. Some common methods should be implemented here.
class FilesDao

  constructor: (@log = false) ->
    @db = riak.getClient({debug: @log})


  saveFile: (buffer, key) =>
    @db.saveLarge key, data, {author: "x"},(err, data) =>
      console.log "done",err, data
      @db.getLarge key, (err, buffer, meta) ->
        console.log "read", err, meta


exports.newInstance = (log) -> new FilesDao(log)

