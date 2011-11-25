should = require "should"
User = require("../lib/objects/user").User

describe "new user", ->
  user = new User("anton", "anton@circuithub.com")
  it "shoudl have correct proeprties", ->
    user.id().should.equal "anton"
    user.should.have.property "email", "anton@circuithub.com"
    user.attributes().should.have.property "email", "anton@circuithub.com"


