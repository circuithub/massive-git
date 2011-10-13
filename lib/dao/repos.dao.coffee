Dao  = require("./dao").Dao
Repo = require("../objects/repo").Repo

class ReposDao extends Dao

  constructor: ->
    super "repositories"

  populateEntity: (meta, attributes) =>
    author = @getLink meta.links, "author"
    forkedFrom = @getLink meta.links, "forked_from"
    commit = @getLink meta.links, "commit"
    new Repo(attributes.name, author, attributes.type, attributes.public, commit, forkedFrom)

#["and", [["starts_with", user]], [["starts_with", user]]] })
# todo (anton) filtering by type somehow doesn't work. Check it.
  findAll: (user, type, callback) =>
    @db
     .add({ bucket: @bucket, key_filters: [["tokenize", "$", 1],["eq", user]]})
     .map (value) ->
        row = value.values[0]
        entity = {}
        entity.attributes = JSON.parse(row.data)
        metadata = row.metadata
        userMeta = metadata["X-Riak-Meta"]
        entity.meta = {}
        entity.meta.key = value.key
        linksArray = metadata["Links"]
        links =[]
        for link in linksArray
          links.push {bucket : link[0], key : link[1], tag : link[2] }
        entity.meta.links = links
        [entity]
     .run (err, docs) =>
       if(err)
         callback err
       else
         repos = (@populateEntity doc.meta, doc.attributes for doc in docs)
         callback undefined, repos

exports.newInstance = -> new ReposDao()

