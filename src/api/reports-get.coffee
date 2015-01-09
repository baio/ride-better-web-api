"use strict"

threads = require "../data-access/board/threads"
summaryFormatter = require "./summaryFormatter"
moment = require "moment"
_ = require "underscore"

module.exports = (opts) ->
  _.defaults opts, lang : "en", culture : "eu"
  threads.getThreads([opts.spot, "report"]).then (res) ->
    res.map (r) ->
      if r.meta.operate?.openDate
        r.meta.operate.openDate = moment.utc(r.meta.operate.openDate).unix()
      if r.meta.conditions
        summary = summaryFormatter.summary(opts.lang, r.meta.conditions)
      else if r.meta.operate
        summary = summaryFormatter.notOperate(opts.lang, r.meta.operate)

      r.summary = summary
      r.time = moment.utc(r.time).unix()
      r

