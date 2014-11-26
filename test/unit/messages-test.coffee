expect = require("chai").expect
moment = require "moment"

describe "test board api", ->

  it "create message for 1936", (next) ->
    data =
      message : "test"
    @server.inject url : "/spots/1936/messages", method: "post", payload : data, credentials : @user, (resp) =>
      @messageId = resp.result._id
      console.log resp.result
      next()

  it "get messages for 1936", (next) ->
    @server.inject url : "/spots/1936/messages", method: "get", (resp) =>
      console.log resp.result
      next()

  it "delete messages for 1936", (next) ->
    @server.inject url : "/messages/#{@messageId}", method: "delete", credentials : @user, (resp) =>
      console.log resp.result
      next()

