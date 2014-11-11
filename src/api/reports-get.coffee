"use strict"
Q = require "q"
reportModel = require "../models/report"
moment = require "moment"
summaryFormatter = require "./summaryFormatter"

module.exports = (lang, spot, allDates) ->
  lang ?= "en"
  q =
    spot : spot
  if !allDates
    dateFrom = moment.utc().add(-2, "d").startOf("d").valueOf()
    q.time = $gte : dateFrom
  console.log ">>>reports-get.coffee:14", q
  Q(reportModel.find(q).sort(time : -1).limit(25).exec()).then (res) ->
    res.map (m) ->
      r = m.toObject virtuals: true
      if r.operate?.openDate
        r.operate.openDate = r.operate.openDate.unix
      delete r._id
      delete r.__v
      user : r.user
      time : r.time.unix
      conditions : r.conditions
      operate : r.operate
      comment : r.comment
      summary : if r.conditions then summaryFormatter.summary(lang, r.conditions) else summaryFormatter.notOperate(lang, r.operate)
