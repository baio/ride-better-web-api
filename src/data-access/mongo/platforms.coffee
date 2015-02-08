mongo = require "./mongo"

exports.add = (data) ->
  mongo.platforms.insertAsync(data)