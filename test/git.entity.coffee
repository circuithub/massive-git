should    = require "should"
GitEntity = require("../lib/objects/git.entity").GitEntity

class TestEntity extends GitEntity

  constructor: (@_id, @prop1, @prop2) ->

  attributes: =>
    prop1 : @prop1

exports.testToJson = ->
  entity = new TestEntity("some-id", 1, 4)
  entity.id().should.equal "some-id"
  entity.should.have.property "prop1", 1
  entity.should.have.property "prop2", 4
  entity.links().should.be.empty
  entity.attributes().should.have.property "prop1", 1
  entity.toJSON().should.have.property "prop1", 1
  entity.toJSON().should.have.property "id", "some-id"

