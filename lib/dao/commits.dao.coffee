Commit     = require("../objects/commit").Commit
ObjectsDao = require("./objects.dao").ObjectsDao

class CommitsDao extends ObjectsDao

  populateEntity: (meta, attributes) =>
    if attributes?
      tree = @getLink meta.links, "tree"
      parent = @getLink meta.links, "parent"
      author = @getLink meta.links, "author"
      committer = @getLink meta.links, "committer"
      repository = @getLink meta.links, "repository"
      authorEmail = attributes.authorEmail
      committerEmail = attributes.committerEmail
      authoredDate = attributes.authoredDate
      commitedDate = attributes.commitedDate
      new Commit(tree, parent, author, authorEmail, authoredDate, committer, committerEmail, commitedDate, attributes.message, repository, meta.key)

  getParents: (commitId, callback) =>
    @links commitId, [["objects", "parent", 1],["objects", "parent", 1],["objects", "parent", 1],["objects", "parent", 1],["objects", "parent", 1],["objects", "parent", 1],["objects", "parent", 1],["objects", "parent", 1],["objects", "parent", 1],["objects", "parent", 1]], (err, docs) =>
      if err
        callback err
      else
        commits = []
        for doc in docs
          data = doc.data
          commit = @populateEntity(doc.meta, data)
          commits.push commit if commit?
        # fetching initial commit by specified i. NOTE (anton) refactor it. We fetching this list in 2 requests here
        @get commitId, (err, commit) ->
          if err 
            callback undefined, commits
          else
            commits.unshift commit
            callback undefined, commits

exports.newInstance = (log) -> new CommitsDao(log)
