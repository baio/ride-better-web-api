report = require "./short-report-get"
mswForecast = require "./msw-forecast-get"
Q = require "q"
moment = require "moment"

module.exports = (spot) ->
  Q.all([report(spot), mswForecast(spot)])
  .spread (report, forecast) ->
      dt = moment.utc  forecast.dateRange.exact
      cdt = forecast.conditions.filter((f) -> moment.utc(f.dateTime) <= dt).reverse()[0]
      idx = forecast.conditions.indexOf cdt
      forecasts = [cdt]
      forecasts.push(forecast.conditions[idx + 1]) if idx != forecast.conditions.length - 1
      spot : spot
      reports : report
      forecast : forecasts.map (m) -> rating : m.rating, dt : m.dateTime
