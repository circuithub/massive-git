

# Repo
# ---------
# Class representing repository.
# `id` - unique repository id. URL can be used as unique repository identifier.
# `type` - type of the repository. Set by each client of this library. After exporting to Git new file `schema.json` should be hold information about `type` of the repository.
# `public` - flag that indicated whether repo is public or private. Default to `true`.
# `forked_from` - id of the repository from which this was cloned. Default to `null`.
class Repo
  constructor: (@id, @type, @public = true, @forked_from = null) ->

  commits: =>

  commitAll: (message)

exports.Repo = Repo

