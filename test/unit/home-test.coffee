expect = require("chai").expect

homeGet = require "../../src/api/home-get"

describe "test home api", ->

  it "get home for spot 1936", (next) ->
    homeGet(spot : "1936").then (res) ->
      console.log ">>>reports-test.coffee:9", res
      next()

