GitObject = require("./git.object").GitObject

# Blob
# -----------
# Class representing Git `blob`. Blob can store data of any type.
# User can additionaly specify content type for the blob by `contentType` property.
Blob = exports.Blob = class Blob extends GitObject

  # Constructor takes `data` and optionally `repo` id and blob's `id`.
  constructor: (@data, @repo = null, @_id = null, @contentType) ->
    super "blob", @repo, @_id

  content: => @data

  # Dao related methods.
  # ---------

  # User can explicitly specify content type of the blob.
  #contentType:@contentType

  # Method for getting plain `attributes` of the GitObject.
  attributes: => @data

