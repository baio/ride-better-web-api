"use strict"
Q = require "q"
skimapModel = require "../models/skimap"
moment = require "moment"
Forecast = require "forecast.io"
cache = require "../cache"

forecast = new Forecast
  APIKey: "c627c992deb04400940b50c6e1ee0562"
#celcius

request = (spot) ->
  promise = Q.nbind(skimapModel.findOne, skimapModel)(id : spot, latitude : $exists : true)
  promise = promise.then (res) ->
    if res
      Q.nbind(forecast.get, forecast)(res.latitude,res.longitude,units : "si")
    else
      throw new Error "Not Found"
  promise.then (r) ->
    if r and r[1]
      data = r[1]
      #time is return in UTC, this means we need to know local tz to convert it in actual time.
      #straighforward convert by index
      day = moment.utc().startOf('day')
      data.daily.data.map (d) ->
        res =
          time : day.unix()
          summary: d.summary
          precipType: d.precipType
          precipAccumulation: d.precipAccumulation
          temperatureMin: d.temperatureMin
          temperatureMax: d.temperatureMax
        day = day.add 1, "d"
        res
    else
      throw new Error "Unknow Error"
  , (err) ->
    if err.message == "Not Found"
      []

module.exports = (spot) ->
  promise = cache.get("forecastio-forecast", spot)
  promise.then (res) ->
    d1 = moment.utc(res.items[0].time, "X").dayOfYear() if res and res.length
    d2 = moment.utc().dayOfYear()
    if !res or d1 != d2
      request(spot).then (res) ->
        cache.set "forecastio-forecast", spot, items : res, 1000 * 60 * 60 * 24
        res
    else
      console.log ">>>forecast-get.coffee:48", "from cache"
      res.items


