Forecast = require "forecast.io"
Promise = require "bluebird"
config = require("../../config")
forecast = Promise.promisifyAll new Forecast(APIKey: config("FORECASTIO_KEY"))

exports.getForecast = (geo, opts) ->
  units = opts.culture
  units = "si" if units = "eu"
  forecast.getAsync(geo.latitude, geo.longitude, {units : units, lang : opts.lang}).then (res) ->
    if res and res[1]
      return res[1]
    else
      throw new Error "Forecast.io return no results"
