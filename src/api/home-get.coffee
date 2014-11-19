"use strict"

moment = require "moment"
summaryFormatter = require "./summaryFormatter"
reportsGet = require "./reports-get"
forecastGet = require "./forecast-get"
snapshotGet = require "./snapshot-get"
Promise = require "bluebird"

module.exports = (opts) ->
  Promise.join reportsGet(opts), forecastGet(opts), (reports, forecast) ->
    snapshotGet(opts, reports, forecast).then (snapshot) ->
      reports : reports
      forecast : forecast
      snapshot : snapshot