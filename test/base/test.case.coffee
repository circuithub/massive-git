async  = require "async"
should = require "should"

TestCase = exports.TestCase = class TestCase

  constructor: (@steps...) ->

  run: =>
    try
      async.waterfall @steps, (err, results) =>
        @tearDown()
        should.not.exist err
    catch err
      @tearDown()

  tearDown: ->

