"use strict"
Q = require "Q"
reportModel = require "../models/report"
moment = require "moment"
summaryFormatter = require "./summaryFormatter"

module.exports = (lang, spot) ->
  dateFrom = moment.utc().add(-2, "d").toDate()
  q =
    spot : spot
    time : $gte : dateFrom
  Q(reportModel.find(q).sort(time : -1).limit(25).exec()).then (res) ->
    res.map (m) ->
      r = m.toObject virtuals: true
      delete r._id
      delete r.__v
      user : r.user
      time : r.time.unix
      conditions : r.conditions
      operate : r.operate
      comment : r.comment
      summary : if r.conditions then summaryFormatter.summary(lang, r.conditions) else summaryFormatter.operate(lang, r.operate.status)
