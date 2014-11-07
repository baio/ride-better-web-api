"use strict"
Q = require "Q"
forecastGet = require "./forecast-get"

module.exports = (spot) ->
  forecastGet(spot).then (res) ->
    forecast : res[0]
    report :
      status : "operate"
      summary : "Today many users report great conditions of snow cover and snowing. A lot of people riding, you should definitely join!"
      conditions:
        snow : 4
        track : 4
        crowd : 4
