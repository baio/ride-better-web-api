Promise = require "bluebird"
config = require("../../config")
_request = require "request"
_request.debug = true

request = Promise.promisifyAll _request
boardUri = config("BOARD_URI")

exports.post = (path, data) ->

  if req.params.tag
    tags = req.params.tag.split "-"
  boardDoc =
    _id : id
    app : req.auth.credentials.key
    spot : req.params.spot
    title : req.payload.title
    tags : tags
    _user : req.payload._user

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

exports.remove = (path, data) ->
  request.delAsync(boardUri + "/" + path, json : if data then data else true).then (res) ->
    if res[0].statusCode != 200
      throw new Error res.statusCode
    else
      res[1]