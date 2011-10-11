GitObject = require("./git.object").GitObject

# todo (anton) author and commiter should also store date!!!!!!!!!!
class Commit extends GitObject

  # Constructor takes mandatory `Commit` properties and optionally `repo` id and commit's `id`.
  constructor: (@tree, @parent, @author, @authoredDate, @committer, @commitedDate, @message, @repo = null, @_id = null) ->
    super "commit", @repo, @_id

  # todo (anton) author and commiter here should keep authore and commited date. Only in this way sha will be Git compatible
  content: =>
    parentToken = ""
    parentToken += "parent" + char for char in @parent if @parent # todo (anton) check what to do if parent is null. In case of first commit
    "tree " + @tree + "\n" + parentToken + "author " + @author + "\ncommitter " + @committer + "\n\n" + @message

  # Dao related methods.
  # ---------

  # Method for getting plain `attributes` of the GitObject.
  attributes: =>
    attributes = super()
    attributes.message = @message
    attributes.authoredDate = @authoredDate
    attributes.commitedDate = @commitedDate
    attributes

  # Method for getting `links` that connect this GitObject with another GitObjects, users or repositories.
  links: =>
    links = super()
    links.push @buildLink "objects", @tree, "tree"
    links.push @buildLink "objects", @parent, "parent"
    links.push @buildLink  "users", @author, "author"
    links.push @buildLink "users", @committer, "committer"
    links

exports.Commit = Commit

