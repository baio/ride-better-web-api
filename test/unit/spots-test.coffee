"use strict"
server = require "../../src/server"
expect = require("chai").expect
sinon = require "sinon"

describe "test `spot`", ->

  it "get `/spots?term=завя` should return results", (next) ->

    server.inject url : "/spots?term=завя", method: "get", (resp) ->
      console.log ">>>spot-test.coffee:11", resp.result
      next()

  it "get `/spots?term=zavjal&geo=54.773888,58.526112` should return results", (next) ->

    server.inject url : "/spots?term=zavjal&geo=54.773888,58.526112", method: "get", (resp) ->
      console.log ">>>spot-test.coffee:17", resp.result
      next()

  it "get `/spots?geo=54.773888,58.526112` should return results", (next) ->

    server.inject url : "/spots?geo=54.773888,58.526112", method: "get", (resp) ->
      console.log ">>>spot-test.coffee:23", resp.result
      next()

