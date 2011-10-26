Dao  = require("./dao").Dao
Repo = require("../objects/repo").Repo

class ReposDao extends Dao

  constructor: (log)->
    super "repositories", log

  populateEntity: (meta, attributes) =>
    author = @getLink meta.links, "author"
    forkedFrom = @getLink meta.links, "forked_from"
    commit = @getLink meta.links, "commit"
    new Repo(attributes.name, author, attributes.type, attributes.public, commit, forkedFrom)

  getNewestRepos: (callback) =>
    reduceDescending = ( v , args ) ->
      v.sort ( (a,b) -> return b['lastModifiedParsed'] - a['lastModifiedParsed'] )
      return v
    @db.add(@bucket).map(@_map).reduce(reduceDescending).run (err, docs) =>
      if(err)
         callback err
      else
        console.log "newest repos", docs.length if @log
        repos = (@populateEntity doc.meta, doc.attributes for doc in docs when doc.meta?)
        callback undefined, repos

  searchByName: (name, callback) =>
    @db.add({bucket: @bucket, key_filters: [["matches", name]] }).map(@_map).run (err, docs) =>
      if(err)
         callback err
      else
        console.log "found repos", docs.length if @log
        repos = (@populateEntity doc.meta, doc.attributes for doc in docs when doc.meta?)
        callback undefined, repos

exports.newInstance = (log) -> new ReposDao(log)

