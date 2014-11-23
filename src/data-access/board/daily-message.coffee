board = require "./board"
moment = require "moment"

exports.addMessage = (spot, message) ->
  date = moment().utc().format("DD-MM-YYYY")
  board.post("spots/#{spot}/boards/#{date}/daily-talk/threads", message).then (res) ->
    res.message.created = moment.utc(res.message.created).unix()
    res

exports.getMessages = (spot) ->
  date = moment().utc().format("DD-MM-YYYY")
  board.get("spots/#{spot}/boards/#{date}/daily-talk/threads").then (res) ->
    if res
      for thread in res.threads
        thread.message.created = moment.utc(thread.message.created).unix()
    res
