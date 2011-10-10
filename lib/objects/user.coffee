GitEntity = require("./git.entity").GitEntity

# User
# ------------
# Class represent information about user in the system.
# User has `id` (which is username), `email` and registration `date`.
class User extends GitEntity

  constructor: (@_id, @email, @date) ->

  # Dao related methods.
  # ---------

  # Method for getting plain `attributes` of the GitObject.
  attributes: =>
    attributes =
      email : @email
      date  : @date

exports.User = User

