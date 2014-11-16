"use strict"
Q = require "q"
reportModel = require "../models/report"

module.exports = (user, spot, data) ->
  data.user = user
  data.spot = spot
  report = new reportModel data
  if data.operate?.openDate
    report.set "operate.openDate.unix", data.operate.openDate
  console.log ">>>reports-post.coffee:10", report.operate.openDate
  Q.nbind(report.save, report)()
