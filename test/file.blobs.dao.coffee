fs       = require "fs"
filesDao = require("../lib/dao/file.blobs.dao").newInstance(true)
FileBlob = require("../lib/objects/file.blob").FileBlob

exports.testSaveFile = ->
  fs.readFile "/home/podviaznikov/circuithub/circuithub/server.coffee", (err, data) ->
    fileBlob = new FileBlob(data,"x","unique-id")
    filesDao.save fileBlob, (err, ok) ->
      console.log "file was saved", err, ok

