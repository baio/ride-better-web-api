expect = require("chai").expect

homeGet = require "../../src/api/home-get"

describe "test home api", ->

  it "get home for spot 1936 (service)", (next) ->
    homeGet(spot : "1936").then (res) ->
      console.log ">>>reports-test.coffee:9", res
      next()

  it "get home for spot 1936", (next) ->
    @server.inject url : "/home/1936?lang=en", method: "get", (resp) ->
      console.log ">>>reports-test.coffee:9", resp.result
      next()

