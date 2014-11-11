"use strict"
server = require "../../src/server"
expect = require("chai").expect
moment = require "moment"

describe "test `closed reports`", ->

  it "post `/reports/1936` must return results", (next) ->

    credentials = key : "test_1", id : "1", name : "baio", avatar : "unk.png", provider : "test"

    data =
      operate :
        status : "day-off"
        openDate : moment("2014-11-10").unix()
      comment : "blqah blah balh"

    server.inject url : "/reports/1936", method: "post", payload : JSON.stringify(data), credentials : credentials, (resp) ->
      console.log ">>>closed-reports-test.coffee:16", resp.result
      next()

  it "get `/snapshot/1936` must return results", (next) ->

    server.inject url : "/snapshot/1936", method: "get", (resp) ->
      console.log ">>>reports-test.coffee:41", resp.result
      next()
