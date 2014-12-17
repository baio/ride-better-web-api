"use strict"

joi = require "joi"
hapi = require "hapi"
boardApi = require "../../api/boards"

paramsValidationSchema =
  board : joi.string().required()
  spot : joi.string().required()

payloadValidationSchema =
  message : joi.string().required()

module.exports =
  method : "POST"
  path : "/spots/{spot}/boards/{board}/threads"
  config :
    validate :
      params : paramsValidationSchema
      payload : payloadValidationSchema
  handler : (req, resp) ->
    user = req.auth.credentials
    spot = req.params.spot
    board = req.params.board
    boardApi.createThread(user, spot, board, req.payload.message).then (res) ->
      resp res
    , (err) ->
      resp hapi.Error.badRequest err