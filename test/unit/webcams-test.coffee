expect = require("chai").expect

webcams = require "../../src/data-access/webcams"

describe.only "test webcams api", ->

  ###
  it "get latest webcam for spot 1936", (next) ->
    webcams.getLatest("1936").then (res) =>
      console.log ">>>webacms-test.coffee:9", res
      @created = res.created
      next()

  it "get prev webcam for spot 1936", (next) ->
    webcams.getPrev("1936", @created).then (res) =>
      console.log ">>>webacms-test.coffee:15", res
      @created = res.created
      next()

  it "get next webcam for spot 1936", (next) ->
    webcams.getNext("1936", @created).then (res) =>
      console.log ">>>webacms-test.coffee:15", res
      @created = res.created
      next()
  ###

  it "get latest webcam for spot 1936", (next) ->
    @server.inject url : "/webcams/1936/latest", method: "get", (resp) =>
      console.log ">>>webcams-test.coffee:29", resp.result
      @created = resp.result.created
      next()

  it "get prev webcam for spot 1936", (next) ->
    @server.inject url : "/webcams/1936/prev/#{@created}", method: "get", (resp) =>
      console.log ">>>webcams-test.coffee:29", resp.result
      @created = resp.result.created
      next()

  it "get next webcam for spot 1936", (next) ->
    @server.inject url : "/webcams/1936/next/#{@created}", method: "get", (resp) =>
      console.log ">>>webcams-test.coffee:29", resp.result
      @created = resp.result.created
      next()
