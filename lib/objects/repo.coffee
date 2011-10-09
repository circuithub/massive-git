GitEntity = require("./git.entity").GitEntity

# Repo
# ---------
# Class representing repository.
# `id` - unique repository id. URL can be used as unique repository identifier.
# `owner` - repository's owner.
# `type` - type of the repository. Metainformation.
# `public` - flag that indicated whether repo is public or private. Default to `true`.
# `forkedFrom` - id of the repository from which this was cloned. Default to `null`.
class Repo extends GitEntity

  constructor: (@_id, @owner, @type, @public = true, @forkedFrom = null) ->

  # Dao related methods
  # ---------

  # Method for getting plain `attributes` of the GitObject.
  attributes: =>
    attributes =
      type : @type

  # Method for getting `links` that connect this GitObject with another GitObjects, users or repositories.
  links: =>
    owner      = { bucket : "users", key : @owner, tag : "owner"}
    forkedFrom = { bucket : "repositories", key : @forkedFrom, tag : "forked_from"}
    [owner, forkedFrom]

exports.Repo = Repo

