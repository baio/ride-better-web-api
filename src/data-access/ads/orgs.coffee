mongo = require "./mongo"
moment = require "moment"

exports.createOrg = (user, profile) ->
  org =
    user : user
    created : moment().utc().toDate()
    profile : profile
  mongo.orgs.insertAsync(org)

exports.removeOrg = (user) ->
  mongo.orgs.removeAsync("user.key" : user.key)

exports.updateOrg = (user, profile) ->
  mongo.orgs.updateAsync({"user.key" : user.key}, {$set : "profile" : profile})
