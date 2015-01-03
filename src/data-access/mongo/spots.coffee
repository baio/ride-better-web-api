mongo = require "./mongo"

exports.getGeo = (spot) ->
  mongo.resorts.findOneAsync({_id : spot, geo : $exists : true}, {geo : 1}).then (res) ->
    if res
	    latitude : res.geo[0]
	    longitude : res.geo[1]

exports.getSpot = (spot) ->
  mongo.resorts.findOneAsync({_id : spot}, {title : 1}).then (res) ->
    if res
      id : res._id
      title : res.title
