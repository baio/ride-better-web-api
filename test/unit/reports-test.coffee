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

  it "send report for 1936", (next) ->
    credentials = user : name : "baio"
    @server.inject url : "/home/1936", method: "post", payload : payload, (resp) ->
      console.log ">>>reports-test.coffee:9", resp.result
      next()

  it "get reports for 1939", (next) ->
    @server.inject url : "/home/1939", method: "get", (resp) ->
      console.log ">>>reports-test.coffee:19", resp.result
      next()
