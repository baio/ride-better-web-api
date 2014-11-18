"use strict"

report = require "../data-access/mongo/report"
summaryFormatter = require "./summaryFormatter"
_ = require "underscore"

module.exports = (opts) ->
  _.defaults opts, lang : "en", culture : "eu"
  console.log ">>>reports-get.coffee:9"
  report.getLatest2Days(opts.spot).then (res) ->
    console.log ">>>reports-get.coffee:11"
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
      summary : if r.conditions then summaryFormatter.summary(lang, r.conditions) else summaryFormatter.notOperate(opts.lang, r.operate)

