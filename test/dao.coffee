assert   = require "assert"
async    = require "async"
Dao      = require("../lib/dao/dao").Dao

class DaoImpl extends Dao

  constructor: ->
    super "test-bucket"

dao = new DaoImpl()
#helper   = require "./helpers/workspace"

# Base test for any Dao.
# -------------
# Testing following case
# 1. Save project
# 2. Update project
# 3. Add link
# 4. Get project and check it
# 5. Remove link
# 6. get project and check it
# 7. Delete project
exports.testBasicOperations =->
  # special step that check that project exists
  projectExistsStep = (project, callback) =>
    dao.exists project.id, (err, exists) ->
      assert.isUndefined err
      assert.ok exists
      callback err, project
  # create new project
  step1 = (callback) ->
    dao.save "circuithub.com/anton/test-project",{title : "test-project", private : true}, [{bucket : "users", key : "anton", tag : "author"}], (err, project) ->
      assert.equal "test-project", project.attributes.title
      assert.equal true, project.attributes.private
      assert.equal 1, project.meta.links.length
      assert.equal "users", project.meta.links[0].bucket
      assert.equal "anton", project.meta.links[0].key
      assert.equal "author", project.meta.links[0].tag
      callback err, project
  # updating project
  step2 = (project, callback) ->
    project.attributes.title = "new-project-title"
    dao.save project, (err, project) ->
      assert.equal "new-project-title", project.attributes.title
      assert.equal true, project.attributes.private
      assert.equal 1, project.meta.links.length
      assert.equal "users", project.meta.links[0].bucket
      assert.equal "anton", project.meta.links[0].key
      assert.equal "author", project.meta.links[0].tag
      callback err, project
  # adding link to project
  step3 = (project, callback) ->
    dao.addLink project.id, {bucket : "parts", key : "test-part", tag : "part"}, (err, project) ->
      assert.equal "new-project-title", project.attributes.title
      assert.equal true, project.attributes.private
      assert.equal 2, project.meta.links.length
      assert.equal "users", project.meta.links[0].bucket
      assert.equal "anton", project.meta.links[0].key
      assert.equal "author", project.meta.links[0].tag
      assert.equal "parts", project.meta.links[1].bucket
      assert.equal "test-part", project.meta.links[1].key
      assert.equal "part", project.meta.links[1].tag
      callback err, project
   # get project and check it
  step4 = (project, callback) ->
    dao.get project.id, (err, project) ->
      assert.equal "new-project-title", project.attributes.title
      assert.equal true, project.attributes.private
      assert.equal 2, project.meta.links.length
      assert.equal "users", project.meta.links[0].bucket
      assert.equal "anton", project.meta.links[0].key
      assert.equal "author", project.meta.links[0].tag
      assert.equal "parts", project.meta.links[1].bucket
      assert.equal "test-part", project.meta.links[1].key
      assert.equal "part", project.meta.links[1].tag
      callback err, project
  # remove link to project
  step5 = (project, callback) ->
    dao.removeLink project.id, {bucket : "parts", key : "test-part", tag : "part"}, (err, project) ->
      assert.equal "new-project-title", project.attributes.title
      assert.equal true, project.attributes.private
      assert.equal 1, project.meta.links.length
      assert.equal "users", project.meta.links[0].bucket
      assert.equal "anton", project.meta.links[0].key
      assert.equal "author", project.meta.links[0].tag
      callback err, project
   # get project and check it
  step6 = (project, callback) ->
    dao.get project.id, (err, project) ->
      assert.equal "new-project-title", project.attributes.title
      assert.equal true, project.attributes.private
      assert.equal 1, project.meta.links.length
      assert.equal "users", project.meta.links[0].bucket
      assert.equal "anton", project.meta.links[0].key
      assert.equal "author", project.meta.links[0].tag
      callback err, project
  # delete project
  step7 = (project, callback) ->
    dao.delete project.id, (err) ->
      assert.isUndefined err
      callback err, project
  # check that project doesn't exist
  step8 = (project, callback) ->
    dao.exists project.id, (err, exists) ->
      assert.isNull err
      assert.ok !exists
  async.waterfall [step1, projectExistsStep, step2, projectExistsStep, step3, projectExistsStep, step4, projectExistsStep, step5, step6, projectExistsStep, step7, step8], (err) ->
    assert.isUndefined err
    dao.deleteAll()

