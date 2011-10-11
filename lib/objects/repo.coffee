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

  constructor: (@name, @owner, @type, @public = true, @forkedFrom = null) ->

  id: =>
    @owner + "$" + @name

  # Dao related methods.
  # ---------

  # Method for getting plain `attributes` of the GitObject.
  attributes: =>
    attributes =
      name   : @name
      type   : @type
      public : @public

  # Method for getting `links` that connect this GitObject with another GitObjects, users or repositories.
  links: =>
    links = []
    links.push @buildLink "users", @owner, "owner"
    if(@forkedFrom)
      links.push @buildLink "repositories", @forkedFrom, "forked_from"
    links

exports.Repo = Repo

