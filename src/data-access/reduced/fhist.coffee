mongo = require "./mongo"
moment = require "moment"
_ = require "underscore"


exports.getSnowHistory = (spots) ->
  mongo.find(_id : $in : spots)
  .then (res) -> 
    res.map (m) -> 
      spot : m._id
      items : m.value.amounts
