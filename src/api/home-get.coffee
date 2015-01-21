"use strict"

moment = require "moment"
summaryFormatter = require "./summaryFormatter"
reportsGet = require "./reports-get"
forecastGet = require "./forecast-get"
snapshotGet = require "./snapshot-get"
snowfallHistory = require "./snowfall-history"
spots = require "../data-access/mongo/spots"
threads = require "./threads"
Promise = require "bluebird"

unitNames =
  eu : ["km", "cm", "C"]
  uk : ["mi", "in", "C"]
  us : ["mi", "in", "F"]


module.exports = (opts) ->
  Promise.join spots.getSpot(opts.spot), reportsGet(opts), forecastGet(opts),
    snowfallHistory.getSummary(opts), threads.getLatestImportantMessages(opts.spot)
  , (spot, reports, forecast, snowfallHistory, latestImportant) ->    
    snapshot = snapshotGet(opts, reports, forecast, latestImportant)
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
    latestImportant : latestImportant       
    snapshot : snapshot    
    snowfallHistory : snowfallHistory