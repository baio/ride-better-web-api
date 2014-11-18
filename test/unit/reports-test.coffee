expect = require("chai").expect

reportsGet = require "../../src/api/reports-get"
lastClosedReportGet = require "../../src/api/last-closed-report-get"

describe "test reports api", ->

  it "get reports for spot 1936", (next) ->
    reportsGet(spot : "1936").then (res) ->
      console.log ">>>reports-test.coffee:9", res
      next()

  it "last closed report for 1936", (next) ->
    lastClosedReportGet(spot : "1936").then (res) ->
      console.log ">>>reports-test.coffee:9", res
      next()