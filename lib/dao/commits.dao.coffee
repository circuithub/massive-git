Commit       = require("../objects/commit").Commit
ObjectsDao = require("./objects.dao").ObjectsDao

class CommitsDao extends ObjectsDao

  populateEntity: (meta, attributes) =>
    tree = @getLink meta.links, "tree"
    parent = @getLink meta.links, "parent"
    author = @getLink meta.links, "author"
    committer = @getLink meta.links, "committer"
    repository = @getLink meta.links, "repository"
    console.log "attr", attributes
    new Commit(tree, parent, author, attributes.authoredDate, committer, attributes.commitedDate ,attributes.message, repository, meta.key)

exports.newInstance = (log) -> new CommitsDao(log)

