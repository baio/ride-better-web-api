"use strict"

stats = require("stats-lite")
reportsGet = require "./reports-get"
lastClosedReportGet = require "./last-closed-report-get.coffee"
summaryFormatter = require "./summaryFormatter"
bluebird = require "bluebird"

module.exports = (opts, reports, forecast) ->
  snapshot =
    forecast : if forecast then forecast[0]
  ###
  totalSnowfall :
    amount : 5
    days : 3
    summary : "Over the past 3 days has dropped 5 cm. of snow."
  ###
  if reports.length
    #there is some reports
    if !reports[0].operate or !reports[0].operate.status or reports[0].operate.status == "open"
      #if latest report not closed !
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
      summary = summaryFormatter.summary opts.lang,
        snowing : Math.round(mSnowing), tracks : Math.round(mTracks), crowd : Math.round(mCrowd), variance
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
      #latest report `closed`
      summary = summaryFormatter.notOperate opts.lang,  reports[0].operate
    snapshot.report =
        summary : summary
        conditions : conditions
        lastStatus : if reports[0] then operate : reports[0].operate, comment : reports[0].comment
    bluebird.resolve snapshot
  else
    #tehere is no reports, find last `closed` report
    lastClosedReportGet(opts).then (res) ->
      if res
        snapshot.report =
          lastStatus : operate : res.operate, comment : res.comment
          summary : summaryFormatter.notOperate opts.lang, res.operate
      else
        snapshot.report = summary : summaryFormatter.noReports opts.lang
      snapshot
