assert = require "assert"
User = require("../lib/objects/user").User

exports.testCreateUser = ->
  user = new User("anton", "anton@circuithub.com")
  assert.equal "anton", user.id()
  assert.equal "anton@circuithub.com", user.email
  # test dao related methods
  assert.equal "anton@circuithub.com", user.attributes().email

