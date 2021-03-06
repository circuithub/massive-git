check    = require("validator").check
sanitize = require("validator").sanitize

class ValidationResult

  constructor: (@errorMessage, @sanitizedParameters...) ->
  
  isValid: => !@errorMessage?

# Validate user's data. `username` and `email` are both mandatory.
exports.validateUser = (username, email) ->
  # sanitize input params before further validation
  username = if username then sanitize(username).trim() else null
  email = if email then sanitize(email).trim() else null
  try
    # check that name and author were specified
    check(username, "Invalid parameters").notNull()
    check(email, "Invalid parameters").notNull()
    # check mimimum and maximum length
    check(username, "Username is out of range").len(3, 20)
    # check email
    check(email, "Email address is invalid").isEmail()
    return new ValidationResult(null, username, email)
  catch e
    return new ValidationResult e.message

# Validate repo's data. `name` and `author` are both mandatory.
exports.validateRepo = (name, author) ->
  # sanitize input params before further validation
  name = if name then sanitize(name).trim() else null
  author = if author then sanitize(author).trim() else null
  try
    # check that name and author were specified
    check(name, "Invalid parameters").notNull()
    check(author, "Invalid parameters").notNull()
    # check mimimum and maximum length
    check(name, "Repository name is out of range").len(3, 20)
    return new ValidationResult(null, name, author)
  catch e
    return new ValidationResult e.message

