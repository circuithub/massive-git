should = require "should"
utils  = require "../lib/objects/utils"

exports.testGetLink = ->
  links = [{bucket: "users", tag: "owner", key: "anton"}, {bucket: "users", tag: "modifier", key: "andrew"}]
  should.equal utils.getLink(links, "modifier"), "andrew"
  should.equal utils.getLink(links, "owner"), "anton"
  should.not.exist utils.getLink links, "contributor"


exports.testGetLinks = ->
  links = [{bucket: "users", tag: "modifier", key: "peter"},{bucket: "users", tag: "owner", key: "anton"}, {bucket: "users", tag: "modifier", key: "andrew"}]
  utils.getLinks(links, "modifier").should.have.length(2)
  utils.getLinks(links, "modifier").should.contain "peter"
  utils.getLinks(links, "modifier").should.contain "andrew"
  utils.getLinks(links, "contributor").should.be.empty

exports.testBuilLink = ->
  link = utils.buildLink "users", "anton", "owner"
  link.should.have.property("bucket", "users")
  link.should.have.property("key", "anton")
  link.should.have.property("tag", "owner")

