expect = require("chai").expect

homeGet = require "../../src/api/home-get"

describe "test home api", ->

  it.only "get home for spot 1936 (service)", (next) ->
    homeGet(spot : "1936", lang : "en", culture : "eu").then (res) ->
      console.log ">>>reports-test.coffee:9", res
      next()

  it "get home for spot 1936", (next) ->
    @server.inject url : "/home/1936?lang=en", method: "get", (resp) ->
      console.log ">>>reports-test.coffee:9", resp.result
      #http://localhost:8001/home/1939?culture=eu&lang=en
      next()


  it "get home for spot 1939", (next) ->
    @server.inject url : "/home/1939?culture=eu&lang=en", method: "get", (resp) ->
      console.log ">>>reports-test.coffee:9", resp.result
      next()
