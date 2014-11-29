"use strict"

reports = require "../data-access/mongo/reports"
summaryFormatter = require "./summaryFormatter"
moment = require "moment"
_ = require "underscore"

module.exports = (opts) ->
  _.defaults opts, lang : "en", culture : "eu"
  reports.getLatest(opts.spot).then (res) ->
    res.map (r) ->
      if r.operate?.openDate
        r.operate.openDate = moment.utc(r.operate.openDate).unix()
      if r.conditions
        summary = summaryFormatter.summary(opts.lang, r.conditions)
      else if r.operate
        summary = summaryFormatter.notOperate(opts.lang, r.operate)

      r.summary = summary
      r.time = moment.utc(r.time).unix()
      r

