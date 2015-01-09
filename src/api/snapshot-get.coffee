"use strict"

stats = require("stats-lite")
reportsGet = require "./reports-get"
summaryFormatter = require "./summaryFormatter"
bluebird = require "bluebird"
moment = require "moment"

module.exports = (opts, reports, forecast) ->

  from = moment.utc().add(-1, "d").startOf("d").unix()
  to = moment.utc().unix()
  latestNotClosedReports = reports.filter((f) ->
    (!f.data.meta.operate or f.data.meta.operate.status == "open") and f.data.created >= from and f.data.created <= to
  )
  isFirstReportSuggestClosed = reports[0]?.data.meta.operate?.status and reports[0].data.meta.operate.status != "open"
  if !isFirstReportSuggestClosed and latestNotClosedReports.length
    #Aggregate reports info here
    snowing = latestNotClosedReports.map (m) -> m.data.meta.conditions.snowing if m.data.meta.conditions
    tracks = latestNotClosedReports.map (m) -> m.data.meta.conditions.tracks if m.data.meta.conditions
    crowd = latestNotClosedReports.map (m) -> m.data.meta.conditions.crowd if m.data.meta.conditions
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
  else if reports[0]
    #tehere is no operational reports, just get first one
    if isFirstReportSuggestClosed
      summary = summaryFormatter.notOperate opts.lang, reports[0].data.meta.operate
    else
      conditions = reports[0]?.data.meta.conditions
      if conditions and (conditions.snowing or conditions.tracks or conditions.crowd)
        summary = summaryFormatter.summary opts.lang, conditions
      else
        summary = reports[0].data.text
  else
    summary = summaryFormatter.noReports opts.lang

  snapshot =
    forecast : if forecast then forecast[0]
    report :
      summary : summary
      conditions : conditions

  snapshot
