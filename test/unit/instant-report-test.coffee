"use strict"
server = require "../../src/server"
expect = require("chai").expect

describe "request `instant-report` route", ->

  it "request `AU_QLD_MA_PCM` must return data", (next) ->

    server.inject url : "/instant-report/AU_QLD_MA_PCM", method: "get", (resp) ->

      console.log resp.result
      next()

  xit "request `forecast/BS_NP_NA_WII/2014-10-10` must return 404 result (spot code not exists)", (next) ->

    expected = statusCode: 404, error: 'Not Found'

    server.inject url : "/forecast/BS_NP_NA_WI/2014-10-10", method: "get", (resp) ->
      expect(resp.result).to.deep.equal expected
      next()

  xit "request `forecast/BS_NP_NA_WI/10-308-2014` must return 501 result (wrong date format)", (next) ->

    expected = statusCode : 400, error : "Bad Request", message : "date fails to match the required pattern", validation: { source: 'params', keys: [ 'date' ] }

    server.inject url : "/forecast/BS_NP_NA_WI/10-308-2014", method: "get", (resp) ->
      expect(resp.result).to.deep.equal expected
      next()
