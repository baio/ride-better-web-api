"use strict"
server = require "../../src/server"
expect = require("chai").expect
sinon = require "sinon"

describe.only "test `spot`", ->

  it "get `/spots?term=zavyal` should return results", (next) ->

    server.inject url : "/spots?term=zavyal&geo=-22.965833,-42.027778", method: "get", (resp) ->
      console.log resp.result
      next()

