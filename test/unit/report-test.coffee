"use strict"
server = require "../../src/server"
expect = require("chai").expect
sinon = require "sinon"

describe "test `report`", ->

  it "post `/report/BR-RJ-AC-PG/surf+` without authorization should fail", (next) ->

    expected =
      statusCode: 401
      error: 'Unauthorized'
      message: 'authorization header not found'

    server.inject url : "/report/BR-RJ-AC-PG/surf+", method: "post", (resp) ->
      expect(resp.result).to.deep.equal expected
      next()

  it "post authoriized `/report/BR-RJ-AC-PG/surf+` must return 200 result and id of report", (next) ->

    #clock = sinon.useFakeTimers(new Date(Date.UTC(2014, 1, 1)).getTime())

    credentials = id : "test_user", name : "baio", img : "unk.png"

    server.inject url : "/report/BR-RJ-AC-PG/surf+", method: "post", credentials : credentials, (resp) =>
      expect(resp.result.id).to.be.ok
      @reportId = resp.result.id
      next()

  it "post `/report/{id}/comment` must return 200 result and ok", (next) ->

    expected = ok : true

    credentials = id : "test_user", name : "baio", img : "unk.png"

    server.inject url : "/report/#{@reportId}/message", credentials : credentials, payload : JSON.stringify(text : "blah blah blah"), method: "post", (resp) ->
      console.log resp.result
      expect(resp.result).to.deep.equal expected
      next()

  it "get `/report/BR-RJ-AC-PG` must return 200 result and previous report", (next) ->

    server.inject url : "/report/BR-RJ-AC-PG", method: "get", (resp) ->
      expect(resp.result).to.have.length(1)
      expect(resp.result[0].id).to.be.ok
      expect(resp.result[0].date).to.be.ok
      expect(resp.result[0].user).to.deep.equal id : "test_user", name : "baio", img : "unk.png"
      expect(resp.result[0].code).to.equal "surf+"
      expect(resp.result[0].spot).to.equal "BR-RJ-AC-PG"
      expect(resp.result[0].message).to.equal "blah blah blah"
      next()

