"use strict"
moment = require "moment"
cache = require "../data-access/cache/forecast"
spot = require "../data-access/mongo/spot"
forecast = require "../data-access/forecastio/forecast"
_ = require "underscore"

request = (opts) ->
  spot.getGeo(opts.spot)
  .then (geo) -> forecast.getForecast(geo, opts)
  .then (res) ->
    #time is return in UTC, this means we need to know local tz to convert it in actual time.
    #straighforward convert by index
    day = moment.utc().startOf('day')
    res.daily.data.map (d) ->
      data =
        time : day.unix()
        icon : d.icon
        summary: d.summary
        precipType: d.precipType
        precipAccumulation: d.precipAccumulation
        temperatureMin: d.temperatureMin
        temperatureMax: d.temperatureMax
      day = day.add 1, "d"
      data

module.exports = (opts) ->
  _.defaults opts, lang : "en", culture : "eu"
  cache.getForecast(opts).then (res) ->
    if !res
      request(opts).then (res) ->
        cache.setForecast opts, res
        res
    else
      res


