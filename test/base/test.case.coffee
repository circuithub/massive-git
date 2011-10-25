async    = require "async"
TestCase = exports.TestCase = class TestCase

  constructor: (steps, @cleanup) ->
    @steps = steps

  run: =>
    try
      async.waterfall @steps, @cleanup
    catch err
      @cleanup err

