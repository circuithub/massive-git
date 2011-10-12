assert    = require "assert"
GitEntity = require("../lib/objects/git.entity").GitEntity

class TestEntity extends GitEntity

  constructor: (@_id, @prop1, @prop2) ->

  attributes: =>
    prop1 : @prop1

exports.testToJson = ->
  entity = new TestEntity("some-id", 1, 4)
  assert.equal "some-id", entity.id()
  assert.equal 1, entity.prop1
  assert.equal 4, entity.prop2
  assert.deepEqual [], entity.links()
  assert.deepEqual { prop1 : 1 }, entity.attributes()
  assert.deepEqual { prop1 : 1, id: "some-id" }, entity.toJSON()

