GitObject = require("./git.object").GitObject

class Blob extends GitObject

  # Constructor takes `data` and optionally `repo` id and blob's `id`.
  constructor: (@data, @repo = null, @_id = null) ->
    super "blob", @repo, @_id

  content: =>
    @data

  # Dao related methods.
  # ---------

  # Method for getting plain `attributes` of the GitObject.
  attributes: =>
    attributes = super()
    attributes.data = @data
    attributes

exports.Blob = Blob

