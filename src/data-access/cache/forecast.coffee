cache = require "./cache"
moment = require "moment"

getName = (opts) ->
  opts.spot + "_" + opts.lang + "_" + opts.culture

exports.getForecast = (opts) ->
  name = getName(opts)
  cache.get("forecastio-forecast", name).then (res) ->
    if res
      d1 = moment.utc(res.items[0].time, "X").dayOfYear()
    d2 = moment.utc().dayOfYear()
    if !res or d1 != d2
      if res
        cache.remove name
      null
    else
      res.items

exports.setForecast = (opts, items) ->
  cache.set "forecastio-forecast", getName(opts), items : items, 1000 * 60 * 60 * 24