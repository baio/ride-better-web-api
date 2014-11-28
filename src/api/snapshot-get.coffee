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
    (!f.operate or f.operate.status == "open") and f.time >= from and f.time <= to
  )
  isFirstReportSuggestClosed = reports[0]?.operate?.status and reports[0].operate.status != "open"
  if !isFirstReportSuggestClosed and latestNotClosedReports.length
    #Aggregate reports info here
    snowing = latestNotClosedReports.map (m) -> m.conditions.snowing if m.conditions
    tracks = latestNotClosedReports.map (m) -> m.conditions.tracks if m.conditions
    crowd = latestNotClosedReports.map (m) -> m.conditions.crowd if m.conditions
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
      console.log ">>>snapshot-get.coffee:51", reports[0]
      summary = summaryFormatter.notOperate opts.lang, reports[0].operate
    else
      conditions = reports[0]?.conditions
      if conditions and (conditions.snowing or conditions.tracks or conditions.crowd)
        summary = summaryFormatter.summary opts.lang, conditions
      else
        summary = reports[0].comment
  else
    summary = summaryFormatter.noReports opts.lang

  snapshot =
    forecast : if forecast then forecast[0]
    report :
      summary : summary
      conditions : conditions

  snapshot
