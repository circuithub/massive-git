filesDao = require("../lib/dao/files.dao").newInstance(true)

exports.testSaveFile = ->
  filesDao.saveFile "/home/podviaznikov/circuithub/circuithub/server.coffee", "y"

