assert = require "assert"
User = require("../lib/objects/user").User

exports.testCreateUser = ->
  date = new Date().getTime()
  user = new User("anton", "anton@circuithub.com", "encoded_password",date)
  assert.equal "anton", user.id()
  assert.equal "anton@circuithub.com", user.email
  assert.equal "encoded_password", user.password
  assert.equal date, user.date
  # test dao related methods
  assert.equal "anton@circuithub.com", user.attributes().email
  assert.equal date, user.attributes().date

