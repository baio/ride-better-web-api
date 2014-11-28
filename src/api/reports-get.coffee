"use strict"

report = require "../data-access/mongo/report"
summaryFormatter = require "./summaryFormatter"
_ = require "underscore"

module.exports = (opts) ->
  _.defaults opts, lang : "en", culture : "eu"
  report.getLatest2Days(opts.spot).then (res) ->
    res.map (m) ->
      r = m.toObject virtuals: true
      if r.operate?.openDate
        r.operate.openDate = r.operate.openDate.unix
      if res.conditions
        summary = summaryFormatter.summary(opts.lang, res.conditions)
      else if res.operate
        summary = summaryFormatter.notOperate(opts.lang, res.operate)

      delete r._id
      delete r.__v
      user : r.user
      time : r.time.unix
      conditions : r.conditions
      operate : r.operate
      comment : r.comment
      summary : summary

