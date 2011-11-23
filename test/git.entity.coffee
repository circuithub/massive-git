should    = require "should"
GitEntity = require("../lib/objects/git.entity").GitEntity

class TestEntity extends GitEntity

  constructor: (@_id, @prop1, @prop2) ->

  attributes: =>
    prop1 : @prop1

describe "new entity", ->
  entity = new TestEntity("some-id", 1, 4)  
  it "should have correct properties", ->
		entity.id().should.equal "some-id"
		entity.should.have.property "prop1", 1
		entity.should.have.property "prop2", 4
		entity.links().should.be.empty
		entity.attributes().should.have.property "prop1", 1

describe "entity 'equals'", ->
  entity = new TestEntity("some-id", 1, 4)
  describe "for equal entities", ->
    differentEntity = new TestEntity("some-id", 1, 4)
    it "should return true", -> entity.equals(differentEntity).should.be.ok
  describe "for entities with different ids", ->
    differentEntity = new TestEntity("new-id", 1, 4)
    it "should return false", -> entity.equals(differentEntity).should.be.not.ok
  describe "for entities with different attributes", ->
    differentEntity = new TestEntity("some-id", 2, 4)
    it "should return false", -> entity.equals(differentEntity).should.be.not.ok

