"use strict"

spotModel = require "../models/spot"
dtRange = require "./spot-date-time-range"
msw = require "msw-api"
Q = require "q"
moment = require "moment"
cache = require "../cache"

apiKey = require("yaml-config").readConfig('./configs.yml', process.env.NODE_ENV).msw.key

msw.set({ apiKey: apiKey, units: 'eu' });

getForecast = (spot) ->
  Q(spotModel.findOne({"_id": spot}, {"issuers" : 1, "location.tz" : 1}).exec())
  .then (spotDoc) ->
      if !spotDoc
        throw new Error "404"
      else
        [dtRange.get(spotDoc), msw.forecast(parseInt spotDoc.issuers.filter((f) -> f.name == "msw")[0].code)]
  .spread (range, forecast) ->
      if !forecast
        throw new Error "404"

      res =
        issuer:
          code: "msw"
        dateRange : range
        conditions: []

      for item in forecast._data


        dt = moment.utc item.localTimestamp, "X"
        if dt < range.from or dt > range.to
          continue

        ctn =
          dateTime: dt.format("YYYY-MM-DDTHH:mm:ss")
          weather: item.condition
          wind: item.wind
          swell: item.swell.components.combined
          rating:
            solid: item.solidRating
            faded: item.fadedRating
        res.conditions.push ctn
      res

module.exports = (spot) ->
  cache.get("msw-forecast", spot).then (res) ->
    if res
      res
    else
      return getForecast(spot).then (res) ->
        cache.set "msw-forecast", spot, res, 1000 * 60 * 60
        res

