GitEntity = require("./git.entity").GitEntity

# User
# ------------
# Class represent information about user in the system.
# User has `id` (which is username), `email` and registration `date`.
# todo (anton) Maybe go Grit way: have also simplified Actor entity?? Not sure now.
class User extends GitEntity

  constructor: (@_id, @email, @password, @date) ->

  # Dao related methods.
  # ---------

  # Method for getting plain `attributes` of the GitObject.
  attributes: =>
    attributes =
      email : @email
      date  : @date

exports.User = User

