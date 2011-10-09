crypto = require "crypto"

sha1 = (data) ->
  shasum = crypto.createHash "sha1"
  shasum.update data
  shasum.digest "hex"

# id - SHA
# type
# size
# content
class GitObject

  constructor: (@type, @repo = null) ->

  id: =>
    content = @content()
    header = "#" + @type + " " + content.length + "\0" # type(space)size(null byte)
    store = header + content
    sha1 store

  content: =>
    throw new Error("Should be implemnted in every subclass!")


class Blob extends GitObject

  constructor: (@data, @repo = null) ->
    super "blob", @repo

  content: =>
    @data

class Tree extends GitObject

class Commit extends GitObject

  constructor: (@tree, @parent, @author, @committer, @message, @repo = null) ->
    super "commit", @repo

  content: =>
    parentToken = ""
    parentToken += "parent" + char for char in @parent
    "tree " + @tree + "\n" + parentToken + "author " + @author + "\ncommitter " + @committer + "\n\n" + @message

class Tag extends GitObject


exports.Blob = Blob
exports.Tree = Tree
exports.Commit = Commit

