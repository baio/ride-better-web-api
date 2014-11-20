Forecast = require "forecast.io"
Promise = require "bluebird"
config = require("../../config")
forecast = Promise.promisifyAll new Forecast(APIKey: config("FORECASTIO_KEY"))

exports.getForecast = (opts) ->
  forecast.getAsync(opts.latitude, opts.longitude, units : "si", lang : opts.lang).then (res) ->
    if res and res[1]
      return res[1]
    else
      throw new Error "Forecast.io return no results"
