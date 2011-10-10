assert = require "assert"
utils  = require "../lib/objects/utils"

exports.testGetLink = ->
  links = [{ bucket : "users" , tag : "owner", key : "anton"}, { bucket : "users" , tag : "modifier", key : "andrew"}]
  assert.equal "andrew", utils.getLink links, "modifier"
  assert.equal "anton", utils.getLink links, "owner"
  assert.isNull utils.getLink links, "contributor"

