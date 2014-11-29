"use strict"
moment = require "moment"
cache = require "../data-access/cache/forecast"
spots = require "../data-access/mongo/spots"
forecast = require "../data-access/forecastio/forecast"
_ = require "underscore"

request = (opts) ->
  spots.getGeo(opts.spot)
  .then (geo) ->
    if geo 
      forecast.getForecast(geo, opts).then (res) ->
        # Time is return in UTC, this means we need to know local tz to convert it in actual time.
        # straighforward convert by index
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
    else
      # Geo is not defined for this spot, don't know which data request
      null

module.exports = (opts) ->
  _.defaults opts, lang : "en", culture : "eu"
  cache.getForecast(opts).then (res) ->
    if !res
      request(opts).then (res) ->
        if res
          cache.setForecast opts, res
        res
    else
      res


