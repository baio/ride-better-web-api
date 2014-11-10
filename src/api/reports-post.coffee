"use strict"
Q = require "q"
reportModel = require "../models/report"

module.exports = (user, spot, data) ->
  data.user = user
  data.spot = spot
  report = new reportModel data
  Q.nbind(report.save, report)()
