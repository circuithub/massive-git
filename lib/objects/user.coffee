_         = require "underscore"
GitEntity = require("./git.entity").GitEntity

# User
# ------------
# Class represent information about user in the system.
# User has `id` (which is username) and `email`.
User = exports.User = class User extends GitEntity

  constructor: (@_id, @email, @_links = []) ->

  addLink: (bucket, key, tag) ->
    @_links.push @buildLink bucket, key, tag

  removeLink: (bucket, key, tag) ->
   @_links = _.select @_links, (link) -> link.bucket == bucket and link.key == key and link.tag == tag

  # Dao related methods.
  # ---------

  # Method for getting plain `attributes` of the GitObject.
  attributes: =>
    attributes =
      email : @email

  # Method for getting `links` that connect this GitObject with another GitObjects, users or repositories.
  links: =>
    @_links

