TestCase = require("./test.case").TestCase
helper   = require "../fixture/helper"

DbTestCase = exports.DbTestCase = class DbTestCase extends TestCase

  tearDown: -> helper.deleteAll()

