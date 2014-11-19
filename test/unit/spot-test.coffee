expect = require("chai").expect

spotsGet = require "../../src/api/spots-get"

describe.only "test spots api", ->

  it "get spots for geo 55.76220610000001,37.678805", (next) ->
    spotsGet(null, [55.76220610000001,37.678805]).then (res) ->
      console.log ">>>reports-test.coffee:9", res
      next()
