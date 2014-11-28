mongo = require "./mongo"

exports.getGeo = (spot) ->
  mongo.spots.findOneAsync({id : spot, latitude : $exists : true}, {latitude : 1, longitude : 1}).then (res) ->
    if res
	    latitude : res.latitude
	    longitude : res.longitude