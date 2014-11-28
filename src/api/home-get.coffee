"use strict"

moment = require "moment"
summaryFormatter = require "./summaryFormatter"
reportsGet = require "./reports-get"
forecastGet = require "./forecast-get"
snapshotGet = require "./snapshot-get"
snowfallHistoryGet = require "./snowfall-history-get"
Promise = require "bluebird"

module.exports = (opts) ->
  Promise.join reportsGet(opts), forecastGet(opts), snowfallHistoryGet(opts), (reports, forecast, snowfallHistory) ->
    snapshot = snapshotGet(opts, reports, forecast)
    reports : reports
    forecast : forecast
    snapshot : snapshot
    snowfallHistory : snowfallHistory