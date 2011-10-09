crypto    = require "crypto"
GitEntity = require("./git.entity").GitEntity

sha1 = (data) ->
  shasum = crypto.createHash "sha1"
  shasum.update data
  shasum.digest "hex"

# GitObject
# ------------
# Every git object has following attributes:
# id - SHA as unique identifier.
# type - type of the object: blob, commit, tree or tag.
# content - raw content of the object.
# repo - reference to the repo.
class GitObject extends GitEntity

  constructor: (@type, @repo = null) ->

  id: =>
    content = @content()
    header = "#" + @type + " " + content.length + "\0" # type(space)size(null byte)
    store = header + content
    sha1 store

  content: =>
    throw new Error("Should be implemented in every subclass!")

  # Dao related methods
  # ---------

  # Method for getting plain `attributes` of the GitObject.
  attributes: =>
    attributes =
      type : @type

  # Method for getting `links` that connect this GitObject with another GitObjects, users or repositories.
  links: =>
    repo = { bucket : "repositories", key : @repo, tag : "repository"}
    [repo]

exports.GitObject = GitObject

