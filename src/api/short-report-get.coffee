"use strict"

report = require "./report-get"

module.exports = (spot) ->
  report(spot).then (res) ->
    res.items[0..4].map (m) -> code : m.code, dt : m.date
