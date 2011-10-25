_          = require "underscore"
Dao        = require("./dao").Dao
reposDao   = require("./repos.dao").newInstance()
blobsDao   = require("./blobs.dao").newInstance()
commitsDao = require("./commits.dao").newInstance()
treesDao   = require("./trees.dao").newInstance()
User       = require("../objects/user").User

class UsersDao extends Dao

  constructor: (log) ->
    super "users", log

  populateEntity: (meta, attributes) =>
    new User(meta.key, attributes.email, meta.links)

  findAllRepos: (user, type, callback) =>
    #@db.add("repositories").map(@_map).run (err, docs) =>
    #@db.add('repositories').map('Riak.mapValuesJson').run (err, docs) =>
    @db.add({bucket: "repositories", key_filters: [["starts_with", user]]}).map(@_map).run (err, docs) ->
      if(err)
         callback err
      else
        console.log "retrieved repos", docs if @log
        repos = (reposDao.populateEntity doc.meta, doc.attributes for doc in docs when doc.meta?)
        callback undefined, repos

  # return map:
  fetchAllRepos: (user, type, callback) =>
    @links user, [["repositories", type, 1],["objects", "commit", 1],["objects", "tree", 1],["objects", "blob", 1]], (err, docs) =>
      if(err)
        callback err
      else
        repos = []
        blobs = []
        commits = []
        trees = []
        for doc in docs
          data = doc.data
          if doc.meta.bucket == "repositories"
            repos.push reposDao.populateEntity doc.meta, data
          else if doc.meta.bucket == "objects"
            switch data.type
              when "blob" then blobs.push blobsDao.populateEntity(doc.meta, data)
              when "tree" then trees.push treesDao.populateEntity(doc.meta, data)
              when "commit" then commits.push commitsDao.populateEntity(doc.meta, data)

        callback undefined, {repos: repos, commits: commits, trees: trees, blobs: blobs}

  addRepo: (user, repoId, type, callback) =>
    @get user, (err, user) =>
      if(err)
        callback err
      else
        user.addLink "repositories", repoId, type
        @save user, callback

  removeRepo: (user, repoId, type, callback) =>
    @get user, (err, user) =>
      if(err)
        callback err
      else
        user.removeLink "repositories", repoId, type
        @save user, callback


  watchRepo: (user, repoId, type, callback) =>

  unwatchRepo: (user, repoId, callback) =>


  followUser: (user, userToFollow, callback) =>

  unfollowUser: (user, userToUnfollow, callback) =>

exports.newInstance = (log) -> new UsersDao(log)

