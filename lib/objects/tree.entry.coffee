# TreeEntry
# ----------
# Class represents entry for the `tree`. Each entry has:
# `name` - name of the file or directory
# `mode` - mode for file or directory. Used for tree's `id` claculation.
# `entry` - entry itself. Each entry has `type` and `id`.
TreeEntry = exports.TreeEntry = class TreeEntry

  # Constructor takes `data` and optionally `repo` id and blob's `id`.
  # todo (anton) we can hardcode `mode` right now
  # isFile flag is internal flag to indicate that we are dealing with FileBlob.
  constructor: (@name, @entry, @mode = 100644, @isFile = false) ->

  attributes: =>
    id  : @entry.id()
    name: @name
    type: @entry.type
    mode: @mode

