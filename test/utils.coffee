assert = require "assert"
utils  = require "../lib/objects/utils"

exports.testGetLink = ->
  links = [{ bucket : "users" , tag : "owner", key : "anton"}, { bucket : "users" , tag : "modifier", key : "andrew"}]
  assert.equal "andrew", utils.getLink links, "modifier"
  assert.equal "anton", utils.getLink links, "owner"
  assert.isNull utils.getLink links, "contributor"

exports.testGetLinks = ->
  links = [{ bucket : "users" , tag : "modifier", key : "peter"},{ bucket : "users" , tag : "owner", key : "anton"}, { bucket : "users" , tag : "modifier", key : "andrew"}]
  assert.deepEqual ["peter","andrew"], utils.getLinks links, "modifier"
  assert.deepEqual [], utils.getLinks links, "contributor"

exports.testBuilLink = ->
  assert.deepEqual { bucket : "users" , tag : "owner", key : "anton"}, utils.buildLink "users", "anton", "owner"

