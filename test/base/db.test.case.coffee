TestCase = require("./test.case").TestCase
helper   = require "../fixture/helper"

DbTestCase = exports.DbTestCase = class DbTestCase extends TestCase

  constructor: (steps)->
    super steps, (err, results) -> helper.deleteAll()

