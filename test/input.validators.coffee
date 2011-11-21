should = require "should"
validators = require "../lib/validators/input.validators"

## Validate user

exports.testValidUser = ->
  validators.validateUser("anton", "anton@circuithub.com").isValid().should.be.true

exports.testUserNullUsername = ->
  validators.validateUser(null, "anton@circuithub.com").errorMessage.should.equal "Invalid parameters"

exports.testUserUndefinedUsername = ->
  validators.validateUser(undefined, "anton@circuithub.com").errorMessage.should.equal "Invalid parameters"

exports.testUserEmptyUsername = ->
  validators.validateUser("", "anton@circuithub.com").errorMessage.should.equal "Invalid parameters"

exports.testUserBlankUsername = ->
  validators.validateUser("              ", "anton@circuithub.com").errorMessage.should.equal "Invalid parameters"

exports.testUserShortUsername = ->
  validators.validateUser("bc", "anton@circuithub.com").errorMessage.should.equal "Username is out of range"

exports.testUserLongUsername = ->
  validators.validateUser("123456789azwsxedcrfcrfvtgb", "anton@circuithub.com").errorMessage.should.equal "Username is out of range"

exports.testUserNullEmail = ->
  validators.validateUser("anton", null).errorMessage.should.equal "Invalid parameters"

exports.testUserUndefinedEmail = ->
  validators.validateUser("anton", undefined).errorMessage.should.equal "Invalid parameters"

exports.testUserEmptyEmail = ->
  validators.validateUser("anton", "").errorMessage.should.equal "Invalid parameters"

exports.testUserBlankEmail = ->
  validators.validateUser("anton", "           ").errorMessage.should.equal "Invalid parameters"

exports.testUserInvalidEmail = ->
  validators.validateUser("anton", "anton@com").errorMessage.should.equal "Email address is invalid"

## Validate repo

exports.testValidRepo = ->
  validators.validateRepo("project-one", "anton").isValid().should.be.true

exports.testRepoNullName = ->
  validators.validateRepo(null, "anton").errorMessage.should.equal "Invalid parameters"

exports.testRepoUndefinedName = ->
  validators.validateRepo(undefined, "anton").errorMessage.should.equal "Invalid parameters"

exports.testRepoEmptyName = ->
  validators.validateRepo("", "anton").errorMessage.should.equal "Invalid parameters"

exports.testRepoBlankName = ->
  validators.validateRepo("                ", "anton").errorMessage.should.equal "Invalid parameters"

exports.testRepoShortName = ->
  validators.validateRepo("bc", "anton").errorMessage.should.equal "Repository name is out of range"

exports.testRepoShortName = ->
  validators.validateRepo("123456789azwsxedcrfcrfvtgb", "anton").errorMessage.should.equal "Repository name is out of range"

exports.testRepoNullAuthor = ->
  validators.validateRepo("project-one", null).errorMessage.should.equal "Invalid parameters"

exports.testRepoUndefinedName = ->
  validators.validateRepo("project-one", undefined).errorMessage.should.equal "Invalid parameters"

exports.testRepoEmptyName = ->
  validators.validateRepo("project-one", "").errorMessage.should.equal "Invalid parameters"

exports.testRepoBlankName = ->
  validators.validateRepo("project-one", "       ").errorMessage.should.equal "Invalid parameters"

