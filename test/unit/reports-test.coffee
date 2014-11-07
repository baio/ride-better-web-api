"use strict"
server = require "../../src/server"
expect = require("chai").expect
sinon = require "sinon"

describe "test `reports`", ->

  it "post `/reports/215` without authorization should fail", (next) ->

    expected =
      statusCode: 401
      error: 'Unauthorized'
      message: 'Error: authorization header not found'

    server.inject url : "/reports/1936", method : "post", (resp) ->
      expect(resp.result).to.deep.equal expected
      next()

  it "post authorized `/reports/1936` must return 200 result and id of report", (next) ->

    credentials = key : "test_1", id : "1", name : "baio", avatar : "unk.png", provider : "test"
    data =
      tracks : "good"
      snowing : "good"
      crowd : "good"
      text : "whoa!!!"
    server.inject url : "/reports/1936", method: "post", payload : JSON.stringify(data), credentials : credentials, (resp) ->
      console.log ">>>reports-test.coffee:28", resp.result
      expect(resp.result).to.deep.equal ok : true
      next()

  it "get `/reports/1936` must return results", (next) ->

    expected = [
      spot : "1936"
      user : key : "test_1", id : "1", name : "baio", avatar : "unk.png", provider : "test"
      data :
        tracks : "good"
        snowing : "good"
        crowd : "good"
        text : "whoa!!!"
        operate : true
      ]
    server.inject url : "/reports/1936", method: "get", (resp) ->
      delete r.date for r in resp.result
      console.log ">>>reports-test.coffee:43", resp.result
      expect(resp.result).to.deep.equal expected
      next()
