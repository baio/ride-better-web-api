Promise = require "bluebird"
config = require("../../config")
_request = require "request"
_request.debug = true

request = Promise.promisifyAll _request
boardUri = config("BOARD_URI")

exports.post = (path, data) ->
  request.postAsync(boardUri + "/" + path, json : data).then (res) ->
    console.log res[0].statusCode
    if res[0].statusCode != 200
      throw new Error res.statusCode
    else
      res[1]