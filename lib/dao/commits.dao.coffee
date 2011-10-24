Commit       = require("../objects/commit").Commit
ObjectsDao = require("./objects.dao").ObjectsDao

class CommitsDao extends ObjectsDao

  constructor: (log)->
    super log

  populateEntity: (meta, attributes) =>
    if attributes?
      tree = @getLink meta.links, "tree"
      parent = @getLink meta.links, "parent"
      author = @getLink meta.links, "author"
      committer = @getLink meta.links, "committer"
      repository = @getLink meta.links, "repository"
      authoredDate = attributes.authoredDate
      commitedDate = attributes.commitedDate
      new Commit(tree, parent, author, authoredDate, committer, commitedDate, attributes.message, repository, meta.key)

  getParents: (commitId, callback) =>
    @links commitId, [["objects", "parent", 1],["objects", "parent", 1],["objects", "parent", 1],["objects", "parent", 1],["objects", "parent", 1]], (err, docs) =>
      if(err)
        callback err
      else
        console.log "Commits", docs
        commits = []
        for doc in docs
          data = doc.data
          commit = @populateEntity(doc.meta, data)
          commits.push commit if commit?
        callback undefined, commits

exports.newInstance = (log) -> new CommitsDao(log)

