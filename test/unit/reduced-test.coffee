expect = require("chai").expect

fhist = require "../../src/data-access/reduced/fhist"


describe "test reduced api api", ->

  it "get snow history", (next) ->
    fhist.getSnowHistory("1936").then (res) ->
      console.log ">>>reduced-test.coffee:10", res
