_      = require "underscore"
Entity = require("riak-entity").Entity

# User
# ------------
# Class represent information about user in the system.
# User has `id` (which is username) and `email`.
User = exports.User = class User extends Entity

  constructor: (@_id, @email, @_links = []) ->

  addLink: (bucket, key, tag) =>
    @_links.push @buildLink bucket, key, tag

  removeLink: (bucket, key) =>
   @_links = _.select @_links, (link) -> link.bucket != bucket or link.key != key

  # Dao related methods.
  # ---------

  # Method for getting plain `attributes` of the GitObject.
  attributes: => {email: @email}

  # Method for getting `index`es of the GitObject.
  index: =>
    email: @email

  # Method for getting `links` that connect this user with another GitObjects, users or repositories.
  links: => @_links

