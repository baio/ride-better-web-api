"use strict"

threads = require "../data-access/board/threads"
summaryFormatter = require "./summaryFormatter"
moment = require "moment"
_ = require "underscore"

module.exports = (opts) ->
  _.defaults opts, lang : "en", culture : "eu"
  threads.getThreads(spots : [opts.spot], boards : ["report"]).then (res) ->
    res.map (r) ->
      if r.data.meta.operate?.openDate
        r.data.meta.operate.openDate = moment.utc(r.data.meta.operate.openDate).unix()
      if r.data.meta.conditions
        summary = summaryFormatter.summary(opts.lang, r.data.meta.conditions)
      else if r.data.meta.operate
        summary = summaryFormatter.notOperate(opts.lang, r.data.meta.operate)

      r.data.meta.summary = summary
      r

