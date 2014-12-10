mongo = require "./mongo"
moment = require "moment"
_ = require "underscore"


exports.getSnowHistory = (spot) ->
  mongo.fhist.findOneAsync(_id : spot)
  .then (res) -> res.value.amounts
