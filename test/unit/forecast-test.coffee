expect = require("chai").expect

forecastGet = require "../../src/api/forecast-get"

describe "test forecast api", ->

  it "get forecast for spot 1936", (next) ->
    forecastGet(spot : "1936").then (res) ->
      console.log ">>>forecast-test.coffee:9", res
      next()
