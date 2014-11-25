board = require "../da-board/board"
thread = require "../da-board/thread"
moment = require "moment"

exports.addMessage = (spot, message) ->
  date = moment().utc().format("DD-MM-YYYY")
  id = ["ride-better", spot, date, "daily-talk"].join("_")
  boardDoc =
    _id : id
    app : "ride-better"
    spot : spot
    title : null
    tags : ["daily", "talk"]
    _user : message._user
  board.upsertBoardAndThread(boardDoc, message).then (res) ->
    res.message.created = moment.utc(res.message.created).unix()
    res

exports.getMessages = (spot, opts) ->
  date = moment().utc().format("DD-MM-YYYY")
  id = ["ride-better", spot, date, "daily-talk"].join("_")
  board.getBoard(id, opts).then (res) ->
    if res
      for thd in res.threads
        thd.message.created = moment.utc(thd.message.created).unix()
    res

exports.deleteMessage = (messageId, userKey) ->
  console.log ">>>daily-message.coffee:27", thread
  thread.removeThread(messageId, userKey)
