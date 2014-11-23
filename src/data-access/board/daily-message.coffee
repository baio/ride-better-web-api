board = require "./board"
moment = require "moment"

exports.addMessage = (spot, message) ->
  date = moment().utc().format("DD-MM-YYYY")
  board.post "spots/#{spot}/boards/#{date}/daily-talk/threads", message


exports.getMessages = (spot) ->
  date = moment().utc().format("DD-MM-YYYY")
  board.get "spots/#{spot}/boards/#{date}/daily-talk/threads"
