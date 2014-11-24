Promise = require "bluebird"
config = require("../../config")
_request = require "request"
_request.debug = true

request = Promise.promisifyAll _request
boardUri = config("BOARD_URI")

exports.post = (path, data) ->
  request.postAsync(boardUri + "/" + path, json : data).then (res) ->
    if res[0].statusCode != 200
      throw new Error res.statusCode
    else
      res[1]

exports.get = (path, qs) ->
  request.getAsync(boardUri + "/" + path, json : true, qs : qs).then (res) ->
    if res[0].statusCode != 200
      throw new Error res.statusCode
    else
      res[1]

exports.delete = (path) ->
  request.delAsync(boardUri + "/" + path, json : true).then (res) ->
    if res[0].statusCode != 200
      throw new Error res.statusCode
    else
      res[1]