"use strict"

report = require "../data-access/mongo/report"
summaryFormatter = require "./summaryFormatter"
_ = require "underscore"

module.exports = (opts) ->
  _.defaults opts, lang : "en", culture : "eu"
  report.getCurrentYearLastClosedReport(opts.spot).then (res) ->
    if res
      res = res.toObject virtuals: true
      if res.operate?.openDate
        res.operate.openDate = res.operate.openDate.unix
      if res.conditions
        summary = summaryFormatter.summary(opts.lang, res.conditions)
      else if res.operate
        summary = summaryFormatter.notOperate(opts.lang, res.operate)
      delete res._id
      delete res.__v
      user : res.user
      time : res.time.unix
      conditions : res.conditions
      operate : res.operate
      comment : res.comment
      summary : summary
    else
      null
