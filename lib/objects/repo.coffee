GitEntity = require("./git.entity").GitEntity

# Repo
# ---------
# Class representing repository.
# `id` - unique repository id. Id calculated from `owner`, `type` and `name` of the repository.
# `author` - repository's author.
# `type` - type of the repository. Metainformation.
# `public` - flag that indicated whether repo is public or private. Default to `true`.
# `commit` - last commit for this repository. Can be `null` if repository wasn't commited previously.
# `forkedFrom` - id of the repository from which this was cloned. Default to `null`.
class Repo extends GitEntity

  constructor: (@name, @author, @type, @public = true, @commit, @forkedFrom = null) ->

  id: =>
    @author + "$"+ @name

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
    links.push @buildLink "users", @author, "author"
    if(@forkedFrom)
      links.push @buildLink "repositories", @forkedFrom, "forked_from"
    if(@commit)
      links.push @buildLink "objects", @commit, "commit"
    links

exports.Repo = Repo

