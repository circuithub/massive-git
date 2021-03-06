should = require "should"
validators = require "../lib/validators/input.validators"

describe "user validation", ->
  describe "with valid user", ->
    it "should just work", -> 
      validators.validateUser("anton", "anton@circuithub.com").isValid().should.be.true
  describe "with null username", ->
    it "should return 'Invalid parameters' error", ->
      validators.validateUser(null, "anton@circuithub.com").errorMessage.should.equal "Invalid parameters"
  describe "with undefined username", ->
    it "should return 'Invalid parameters' error", ->
      validators.validateUser(undefined, "anton@circuithub.com").errorMessage.should.equal "Invalid parameters"
  describe "with empty username", ->
    it "should return 'Invalid parameters' error", ->
      validators.validateUser("", "anton@circuithub.com").errorMessage.should.equal "Invalid parameters"
  describe "with blank username", ->
    it "should return 'Invalid parameters' error", ->
      validators.validateUser("            ", "anton@circuithub.com").errorMessage.should.equal "Invalid parameters"
  describe "with short username", ->
    it "should return 'Invalid parameters' error", ->
      validators.validateUser("bc", "anton@circuithub.com").errorMessage.should.equal "Username is out of range"
  describe "with long username", ->
    it "should return 'Invalid parameters' error", ->
      validators.validateUser("123456789azwsxedcrfcrfvtgb", "anton@circuithub.com").errorMessage.should.equal "Username is out of range"
  describe "with null email", ->
    it "should return 'Invalid parameters' error", ->
      validators.validateUser("anton", null).errorMessage.should.equal "Invalid parameters"
  describe "with undefined email", ->
    it "should return 'Invalid parameters' error", ->
      validators.validateUser("anton", undefined).errorMessage.should.equal "Invalid parameters"
  describe "with empty email", ->
    it "should return 'Invalid parameters' error", ->
      validators.validateUser("anton", "").errorMessage.should.equal "Invalid parameters"
  describe "with blank email", ->
    it "should return 'Invalid parameters' error", ->
      validators.validateUser("anton", "     ").errorMessage.should.equal "Invalid parameters"
  describe "with invalid email", ->
    it "should return 'Email address is invalid' error", ->
      validators.validateUser("anton", "anton@com").errorMessage.should.equal "Email address is invalid"

describe "repo validation", ->
  describe "with valid repo", ->
    it "should work fine", ->
      validators.validateRepo("project-one", "anton").isValid().should.be.true  
  describe "with null repo name", ->
    it "should return 'Invalid parameters' error", ->
      validators.validateRepo(null, "anton").errorMessage.should.equal "Invalid parameters"
  describe "with undefined repo name", ->
    it "should return 'Invalid parameters' error", ->
      validators.validateRepo(undefined, "anton").errorMessage.should.equal "Invalid parameters"
  describe "with empty repo name", ->
    it "should return 'Invalid parameters' error", ->
      validators.validateRepo("", "anton").errorMessage.should.equal "Invalid parameters"
  describe "with blank repo name", ->
    it "should return 'Invalid parameters' error", ->
      validators.validateRepo("       ", "anton").errorMessage.should.equal "Invalid parameters"
  describe "with short repo name", ->
    it "should return 'Repository name is out of range' error", ->
      validators.validateRepo("bc", "anton").errorMessage.should.equal "Repository name is out of range"
  describe "with long repo name", ->
    it "should return 'Repository name is out of range' error", ->
      validators.validateRepo("123456789azwsxedcrfcrfvtgb", "anton").errorMessage.should.equal "Repository name is out of range"
  describe "with null author name", ->
    it "should return 'Invalid parameters' error", ->
      validators.validateRepo("project-one", null).errorMessage.should.equal "Invalid parameters"
  describe "with undefined author name", ->
    it "should return 'Invalid parameters' error", ->
      validators.validateRepo("project-one", undefined).errorMessage.should.equal "Invalid parameters"
  describe "with empty author name", ->
    it "should return 'Invalid parameters' error", ->
      validators.validateRepo("project-one", "").errorMessage.should.equal "Invalid parameters"
  describe "with blank author name", ->
    it "should return 'Invalid parameters' error", ->
      validators.validateRepo("project-one", "      ").errorMessage.should.equal "Invalid parameters"

