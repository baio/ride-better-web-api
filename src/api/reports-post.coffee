"use strict"
Q = require "Q"
reportModel = require "../models/report"

module.exports = (user, spot, data) ->
  report = new reportModel user : user, spot : spot, data : data
  Q.nbind(report.save, report)()
