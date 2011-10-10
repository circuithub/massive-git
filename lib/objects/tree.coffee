_         = require "underscore"
GitObject = require("./git.object").GitObject

# todo (anton) each entry (blob or tree) should have name. Think where put this attribute. Without `name` id will be not compatibe with Git.
stringFromEntry = (name, entry) ->
  # todo (anton) we can hardcode `mode` right now
  "644" + " " + entry.type + " " + entry.id() + "\t" + name + "\n"

# Tree
# ---------
# Tree is one of the 4 core Git Objects. Tree stores `entries` which are links to blobs and other trees.
class Tree extends GitObject

  constructor: (entries, @repo = null) ->
    super "tree", @repo
    # Entries are ordered by name as in native Git implementation.
    @entries = _.sortBy entries, (entry) -> entry.name

  content: =>
    rows = ""
    rows += stringFromEntry entry.name, entry.value for entry in @entries
    rows

  # Dao related methods.
  # ---------

  # Method for getting plain `attributes` of the GitObject.
  attributes: =>
    attributes = super()
    attributes.entries = @entries
    attributes

  # Method for getting `links` that connect this GitObject with another GitObjects, users or repositories.
  links: =>
    links = super()
    links

exports.Tree = Tree

