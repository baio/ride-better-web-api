"use strict"
Q = require "Q"
stats = require("stats-lite")
forecastGet = require "./forecast-get"
reportsGet = require "./reports-get"
summaryFormatter = require "./summaryFormatter"

module.exports = (spot) ->
  Q.all [forecastGet(spot), reportsGet(spot)]
  .then (res) ->
    console.log ">>>snapshot-get.coffee:11"
    forecast = res[0]
    reports = res[1]
    if reports.length
      if !reports[0].operate or reports[0].operate.status == "open"
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
        console.log ">>>snapshot-get.coffee:23", mSnowing, vSnowing
        if avgVar <= 1
          variance = 0
        else if avgVar <= 2
          variance = 1
        else
          variance = 2
        summary = summaryFormatter.summary snowing : Math.round(mSnowing), tracks : Math.round(mTracks), crowd : Math.round(mCrowd), variance
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
        summary = "latest report suggests that place is NOT operating"
    else
      summary = "no reports for last two days"

    forecast :
      forecast[0]
    report :
      status : "open"
      summary : summary
      conditions : conditions
