"use strict"

moment = require "moment"
summaryFormatter = require "./summaryFormatter"
reportsGet = require "./reports-get"
forecastGet = require "./forecast-get"
snapshotGet = require "./snapshot-get"
snowfallHistory = require "./snowfall-history"
spots = require "../data-access/mongo/spots"
Promise = require "bluebird"

unitNames =
  eu : ["km", "cm", "C"]
  uk : ["mi", "in", "C"]
  us : ["mi", "in", "F"]


module.exports = (opts) ->
  Promise.join spots.getSpot(opts.spot), reportsGet(opts), forecastGet(opts), snowfallHistory.getSummary(opts), (spot, reports, forecast, snowfallHistory) ->    
    snapshot = snapshotGet(opts, reports, forecast)
    spot : spot
    culture :
      lang : opts.lang
      units : 
        code : opts.culture
        names : 
          temperature : unitNames[opts.culture][2]
          height : unitNames[opts.culture][1]
          distance : unitNames[opts.culture][0]
      code : opts.lang + "-" + opts.culture
    reports : reports
    forecast : forecast
    snapshot : snapshot
    snowfallHistory : snowfallHistory