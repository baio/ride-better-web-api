skimapModel = require "./models/skimap"

exports.getGeo = (spot) ->
  skimapModel.findOneAsync({id : spot, latitude : $exists : true}, {latitude : 1, longitude : 1}).then (res) ->
    latitude : res.latitude
    longitude : res.longitude
