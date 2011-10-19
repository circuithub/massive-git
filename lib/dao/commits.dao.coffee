Commit       = require("../objects/commit").Commit
ObjectsDao = require("./objects.dao").ObjectsDao

class CommitsDao extends ObjectsDao

  constructor: (log)->
    super log

  populateEntity: (meta, attributes) =>
    tree = @getLink meta.links, "tree"
    parent = @getLink meta.links, "parent"
    author = @getLink meta.links, "author"
    committer = @getLink meta.links, "committer"
    repository = @getLink meta.links, "repository"
    authoredDate = attributes.authoredDate
    commitedDate = attributes.commitedDate
    new Commit(tree, parent, author, authoredDate, committer, commitedDate, attributes.message, repository, meta.key)


  getParents: (commitId, callback) =>

exports.newInstance = (log) -> new CommitsDao(log)

