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
    @db = riak.getClient({ debug : true })


  saveFile: (path, key) =>
    fs.readFile path, (err, data) =>
      if (err)
        throw err
      else
        @db.saveLarge key, data, (err, data) =>
          console.log "done",err, data
          @db.getLarge key, (err, buffer) ->
            console.log "read", err, buffer.toString()


exports.newInstance = (log) -> new FilesDao(log)

