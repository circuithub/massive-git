should = require "should"
utils  = require "../lib/objects/utils"

describe "utils#getLink()", ->
  links = [{bucket: "users", tag: "owner", key: "anton"}, {bucket: "users", tag: "modifier", key: "andrew"}]
  it "should find link for correct parameter", ->
    should.equal utils.getLink(links, "modifier"), "andrew"
    should.equal utils.getLink(links, "owner"), "anton"
  it "should return nothing for incorrect parameter", ->
    should.not.exist utils.getLink links, "contributor"

describe "utils#getLinks()", ->
  links = [{bucket: "users", tag: "modifier", key: "peter"},{bucket: "users", tag: "owner", key: "anton"}, {bucket: "users", tag: "modifier", key: "andrew"}]
  it "should return array of links for correct parameters", ->
    utils.getLinks(links, "modifier").should.have.length(2)
    utils.getLinks(links, "modifier").should.contain "peter"
    utils.getLinks(links, "modifier").should.contain "andrew"
  it "should return empty array for incorrect parameters", ->
    utils.getLinks(links, "contributor").should.be.empty

describe "utils#buildLink()", ->
  link = utils.buildLink "users", "anton", "owner"
  it "should return link with correct properties", ->
    link.should.have.property("bucket", "users")
    link.should.have.property("key", "anton")
    link.should.have.property("tag", "owner")


