mongo = require "./mongo"

exports.createOrg = (org, user) ->
  org.user = user
  org.created = moment().utc()
  mongo.orgs.insertAsync(org)

exports.removeOrg = (user) ->
  mongo.orgs.removeAsync("user.key" : user.key)

exports.editOrg = (org, user) ->
  mongo.orgs.updateAsync("user.key" : user.key, org)
