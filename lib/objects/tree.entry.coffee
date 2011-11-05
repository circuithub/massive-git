# TreeEntry
# ----------
# Class represents entry for the `tree`. Each entry has:
# `name` - name of the file or directory
# `entry` - entry itself. Each entry has `type` and `id`.
# `mode` - mode for file or directory. Used for tree's `id` claculation.
TreeEntry = exports.TreeEntry = class TreeEntry

  # Constructor takes `data` and optionally `repo` id and blob's `id`.
  # todo (anton) we can hardcode `mode` right now
  constructor: (@name, @entry, @mode = 100644) ->

  attributes: =>
    id  : @entry.id()
    name: @name
    type: @entry.type
    mode: @mode

