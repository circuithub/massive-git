Dao = require("./dao").Dao

## ObjectsDao
## -------------
## Base Dao for all Git Objects: Blob, Commit, Tree, Tag.
class exports.ObjectsDao extends Dao

  constructor: (log) -> super "objects", log

  # Get link to repository. Can be `null`.
  getRepository: (links) =>  @getLink links, "repository"


