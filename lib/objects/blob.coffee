GitObject = require("./git.object").GitObject

class Blob extends GitObject

  constructor: (@data, @repo = null, @_id = null) ->
    super "blob", @repo

  content: =>
    @data

  # Dao related methods. Code is too riak-specific. Can be refactored later.
  # ---------

  # Method for getting plain `attributes` of the GitObject.
  attributes: =>
    attributes = super()
    attributes.data = @data
    attributes

exports.Blob = Blob

