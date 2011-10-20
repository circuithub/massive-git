should    = require "should"
GitEntity = require("../lib/objects/git.entity").GitEntity

class TestEntity extends GitEntity

  constructor: (@_id, @prop1, @prop2) ->

  attributes: =>
    prop1 : @prop1

exports.testNewEntity = ->
  entity = new TestEntity("some-id", 1, 4)
  entity.id().should.equal "some-id"
  entity.should.have.property "prop1", 1
  entity.should.have.property "prop2", 4
  entity.links().should.be.empty
  entity.attributes().should.have.property "prop1", 1

exports.testEqualsOk = ->
  entity = new TestEntity("some-id", 1, 4)
  differentEntity = new TestEntity("some-id", 1, 4)
  entity.equals(differentEntity).should.be.ok

exports.testEqualsFailedWithDifferentIds = ->
  entity = new TestEntity("some-id", 1, 4)
  differentEntity = new TestEntity("new-id", 1, 4)
  entity.equals(differentEntity).should.be.not.ok

exports.testEqualsFailedWithDifferentAttributes = ->
  entity = new TestEntity("some-id", 1, 4)
  differentEntity = new TestEntity("some-id", 2, 4)
  entity.equals(differentEntity).should.be.not.ok

