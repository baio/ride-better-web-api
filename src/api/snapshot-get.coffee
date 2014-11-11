"use strict"
Q = require "q"
stats = require("stats-lite")
forecastGet = require "./forecast-get"
reportsGet = require "./reports-get"
summaryFormatter = require "./summaryFormatter"

module.exports = (lang, spot) ->
  lang ?= "en"
  promise = Q.all [forecastGet(spot), reportsGet(lang, spot)]
  .then (res) ->
    forecast = res[0]
    reports = res[1]
    if reports.length
      if !reports[0].operate or !reports[0].operate.status or reports[0].operate.status == "open"
        snowing = reports.map (m) -> m.conditions.snowing if m.conditions
        tracks = reports.map (m) -> m.conditions.tracks if m.conditions
        crowd = reports.map (m) -> m.conditions.crowd if m.conditions
        mSnowing = stats.median snowing
        mTracks = stats.median tracks
        mCrowd = stats.median crowd
        vSnowing = stats.stdev snowing
        vTracks = stats.stdev tracks
        vCrowd = stats.stdev crowd
        avgVar = (vSnowing + vTracks + vCrowd) / 3
        if avgVar <= 1
          variance = 0
        else if avgVar <= 2
          variance = 1
        else
          variance = 2
        summary = summaryFormatter.summary lang, snowing : Math.round(mSnowing), tracks : Math.round(mTracks), crowd : Math.round(mCrowd), variance
        conditions =
          conditions:
            snow :
              median : mSnowing
              variance : vSnowing
            tracks :
              median : mTracks
              variance : vTracks
            crowd :
              median : mCrowd
              variance : vCrowd
      else
        summary = summaryFormatter.notOperate lang,  reports[0].operate
    forecast :
      forecast[0]
    report :
      summary : summary
      conditions : conditions
      lastOperate : if reports[0] then operate : reports[0].operate, comment : reports[0].comment

  promise.then (res) ->
    if !res.report.conditions
      reportsGet(lang, spot, true).then (res1) ->
        if res1?[0].operate?.status != "open"
          res.report.lastOperate.operate = res1[0].operate
          res.report.lastOperate.comment = res1[0].comment
          res.report.summary = summaryFormatter.notOperate lang, res1[0].operate
        else
          res.report.summary = summaryFormatter.noReports lang
    res
