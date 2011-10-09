# GitEntity
# -----------
# Base abstract class for each git entity: user, repository, git objects (blobs, commits, trees, tags).
class GitEntity

  # Id of the entity.
  id: =>
    @_id

  # Dao related methods
  # ---------

  # Method for getting plain `attributes` of the GitObject.
  attributes: =>
    throw new Error("Should be implemented in every subclass!")

  # Method for getting `links` that connect this GitEntity with git objects, users or repositories.
  links: =>
    throw new Error("Should be implemented in every subclass!")

exports.GitEntity = GitEntity

