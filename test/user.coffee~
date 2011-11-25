should = require "should"
User = require("../lib/objects/user").User

exports.testUserProperties = ->
  user = new User("anton", "anton@circuithub.com")
  user.id().should.equal "anton"
  user.should.have.property "email", "anton@circuithub.com"
  user.attributes().should.have.property "email", "anton@circuithub.com"

