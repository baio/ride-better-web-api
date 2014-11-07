"use strict"
Q = require "Q"
skimapModel = require "../models/skimap"
moment = require "moment"
Forecast = require "forecast.io"

forecast = new Forecast
  APIKey: "c627c992deb04400940b50c6e1ee0562"
#celcius

module.exports = (spot) ->
  console.log ">>>forecast-get.coffee:12", spot
  promise = Q.nbind(skimapModel.findOne, skimapModel)(id : spot, latitude : $exists : true)
  promise = promise.then (res) ->
    if res
      Q.nbind(forecast.getAtTime, forecast)(res.latitude,res.longitude,units : "si")
    else
      throw new Error "Not Found"
  promise.then (r) ->
    if r and r[1]
      data = r[1]
      data.daily.data.map (d) ->
        time : d.time
        summary: d.summary
        precipType: d.precipType
        precipAccumulation: d.precipAccumulation
        temperatureMin: d.temperatureMin
        temperatureMax: d.temperatureMax
    else
      throw new Error "Unknow Error"