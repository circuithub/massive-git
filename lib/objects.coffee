crypto = require "crypto"

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
class GitObject

  constructor: (@type, @repo = null) ->

  id: =>
    content = @content()
    header = "#" + @type + " " + content.length + "\0" # type(space)size(null byte)
    store = header + content
    sha1 store

  content: =>
    throw new Error("Should be implemented in every subclass!")


class Blob extends GitObject

  constructor: (@data, @repo = null) ->
    super "blob", @repo

  content: =>
    @data

# todo (anton) author and commiter should also store date.
class Commit extends GitObject

  constructor: (@tree, @parent, @author, @committer, @message, @repo = null) ->
    super "commit", @repo

  content: =>
    parentToken = ""
    parentToken += "parent" + char for char in @parent
    "tree " + @tree + "\n" + parentToken + "author " + @author + "\ncommitter " + @committer + "\n\n" + @message

class Tree extends GitObject

# todo (anton) no need to implement at this stage. Can be implemented later
class Tag extends GitObject


exports.Blob = Blob
exports.Tree = Tree
exports.Commit = Commit

