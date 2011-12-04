crypto    = require "crypto"
GitEntity = require("riak-entity").Entity

sha1 = (data) -> crypto.createHash("sha1").update(data).digest("hex")

# GitObject
# ------------
# Every git object has following attributes:
# id - SHA as unique identifier.
# type - type of the object: blob, commit, tree or tag.
# content - raw content of the object.
# repo - reference to the repo.
GitObject = exports.GitObject = class GitObject extends GitEntity

  # Constructor takes `type` of object and optionally `repo` id and internal `_id` of the object.
  constructor: (@type, @repo = null, @_id) ->

  id: =>
    if @_id # return @_id if we have it.
      return @_id
    content = @content()
    header = "#" + @type + " " + content.length + "\0" # type(space)size(null byte)
    store = header + content
    sha1 store

  content: -> throw new Error("Should be implemented in every subclass!")

  # Dao related methods.
  # ---------

  # Method for getting plain `attributes` of the GitObject.
  attributes: -> {}

  # Method for getting `index`es of the GitObject.
  index: =>
    type: @type
    repo: @repo

  # Method for getting `links` that connect this GitObject with another GitObjects, users or repositories.
  links: =>
    links = []
    if @repo
      links.push @buildLink "repositories", @repo, "repository"
    links

  # Get repository for this object.
  getRepository: => @getLink "repository"

