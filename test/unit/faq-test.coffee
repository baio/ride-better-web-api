expect = require("chai").expect

board = require "../../src/data-access/da-board/board"
thread = require "../../src/data-access/da-board/thread"

describe "test faq api", ->

  it "create board FAQ 1936", (next) ->
    bd = 
      spot : "1936"
      title : "FAQ"
      tags : ["1936", "faq"]   
    board.createBoard(bd).then (res) ->
      next()
    , next

  it "create question", (next) ->
    thread.createThread(@user, ["1936", "faq"], "Hi there").then (res) =>
      @threadId = res._id
      next()
    , next

  it "modify question", (next) ->
    thread.updateThread(@user.key, @threadId, "Hi there !").then (res) ->
      next()

  it "create reply", (next) ->
    thread.createReply(@user, @threadId, "Alloha !").then (res) =>
      @replyId = res._id
      next()
    , next

  it "update reply", (next) ->
    thread.updateReply(@user.key, @replyId, "Alloha !!!").then (res) =>
      next()
    , next

  it "get board", (next) ->
    board.getBoard(["1936", "faq"]).then (res) ->
      console.log "faq-test.coffee:40 >>>", res
      next()
    , next


  it "delete reply", (next) ->
    thread.removeReply(@user.key, @replyId).then (res) =>
      next()
    , next

  it "delete question", (next) ->
    thread.removeThread(@user.key, @threadId).then (res) ->
      next()
    , next        

  it "delete board", (next) ->
    board.removeBoard(["1936", "faq"]).then ->
      next()
    , next

