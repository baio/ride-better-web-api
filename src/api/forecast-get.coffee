"use strict"
moment = require "moment"
cache = require "../data-access/cache/forecast"
spots = require "../data-access/mongo/spots"
forecast = require "../data-access/forecastio/forecast"
_ = require "underscore"

mapItem = (d, offset) ->
  time : (d.time + offset * 60 * 60)
  icon : d.icon
  summary: d.summary
  precipType: d.precipType
  precipAccumulation: d.precipAccumulation
  temperatureMin: d.temperatureMin
  temperatureMax: d.temperatureMax
  temperature : d.temperature
  apparentTemperature : d.apparentTemperature

request = (opts) ->
  spots.getGeo(opts.spot)
  .then (geo) ->
    if geo 
      forecast.getForecast(geo, opts).then (res) ->
        ret = res.daily.data.map (m) -> mapItem m, res.offset
        if ret.length and res.hourly          
          for r, i in res.daily.data
            rn = res.daily.data[i + 1]            
            if rn
              hourly = res.hourly.data.filter (f) -> f.time >= r.time and f.time < rn.time
              if hourly.length
                ret[i].hourly = hourly.map (m) -> mapItem m, res.offset
              else
                break
        console.log "forecast-get.coffee:38 >>>"                 
        ret
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


