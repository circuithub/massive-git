GitObject = require("./git.object").GitObject

# todo (anton) each entry (blob or tree) should have name. Think where put this attribute. Without `name` id will be not compatibe with Git.
stringFromEntry = (entry) ->
  # todo (anton) we can hardcode `mode` right now
  "644" + " " + entry.type + " " + entry.id() + "\t" + entry.name + "\n"

class Tree extends GitObject

  constructor: (@entries, @repo = null) ->
    super "tree", @repo

  content: =>
    rows = ""
    rows += stringFromEntry entry for entry in @entries
    rows

exports.Tree = Tree

