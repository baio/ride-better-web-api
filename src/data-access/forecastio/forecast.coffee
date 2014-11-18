Forecast = require "forecast.io"
bluebird = require "bluebird"
config = require("yaml-config").readConfig('./configs.yml', process.env.NODE_ENV)
forecast = bluebird.promisifyAll new Forecast(APIKey: config.forecastio.key)

exports.getForecast = (opts) ->
  forecast.getAsync(opts.latitude, opts.longitude, units : "si").then (res) ->
    if res and res[1]
      return res[1]
    else
      throw new Error "Forecast.io return no results"