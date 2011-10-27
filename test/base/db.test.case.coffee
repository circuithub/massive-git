TestCase = require("./test.case").TestCase
helper   = require "../helper/helper"

DbTestCase = exports.DbTestCase = class DbTestCase extends TestCase

  tearDown: -> helper.deleteAll()

