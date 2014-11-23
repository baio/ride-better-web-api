board = require "./board"
moment = require "moment"

exports.addMessage = (spot, message) ->
  date = moment().utc().format("DD-MM-YYYY")
  console.log spot
  console.log message
  board.post "spots/#{spot}/boards/#{date}/daily-talk/threads", message

