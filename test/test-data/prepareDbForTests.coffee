"use strict"

async = require "async"
models = require "../../src/models"
#sbForecast = require "./surf-better-forecast"
#sbSpot = require "./surf-better-spot"
mswSpot = require "./msw-spot"

module.exports = (done) ->

  async.waterfall [
    (ck) -> models.spot.remove {}, (err) -> ck(err)
    (ck) ->
      mswSpotModel = new models.spot mswSpot
      mswSpotModel.save (err) -> ck(err)
  ], done

###
    (ck) ->
      pgSpotModel = new models.spot pgSpot
      pgSpotModel.save (err) -> ck(err)
    (ck) ->
      pfSpotModel = new models.spot pfSpot
      pfSpotModel.save (err) -> ck(err)
###