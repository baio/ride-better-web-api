expect = require("chai").expect

boards = require "../../src/data-access/da-board/board"

describe.only "test faq service api", ->

  it "get board FAQ 1936", (next) ->

    @server.inject url : "/spots/1936/boards/faq", method: "get", (resp) =>
      next()
    , next

  it "create board FAQ 1936", (next) ->
    @server.inject url : "/spots/1936/boards/faq/threads", method: "post", payload : {message : "test"}, credentials : @user, (resp) =>
      @threadId = resp.result._id
      next()
    , next

  it "modify thread", (next) ->
    @server.inject url : "/spots/boards/threads/#{@threadId}", method: "put", payload : {message : "test !!!"}, credentials : @user, (resp) =>
      next()
    , next

  it "create reply", (next) ->
    @server.inject url : "/spots/boards/threads/#{@threadId}/replies", method: "post", payload : {message : "test !!!"}, credentials : @user, (resp) =>
      @replyId = resp.result._id
      next()
    , next

  it "update reply", (next) ->
    @server.inject url : "/spots/boards/threads/replies/#{@replyId}", method: "put", payload : {message : "test !!!"}, credentials : @user, (resp) =>
      next()
    , next

  it "get board", (next) ->
    @server.inject url : "/spots/1936/boards/faq", method: "get", (resp) =>
      next()
    , next

  it "delete reply", (next) ->
    @server.inject url : "/spots/boards/threads/replies/#{@replyId}", method: "delete", credentials : @user, (resp) =>
      next()
    , next

  it "delete thread", (next) ->
    @server.inject url : "/spots/boards/threads/#{@threadId}", method: "delete", credentials : @user, (resp) =>
      next()
    , next

