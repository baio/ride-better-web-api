report = require "./msw-instant-report-get"
Q = require "q"
moment = require "moment"

module.exports = (spots) ->
  Q.all spots.map (m) -> report(m)
