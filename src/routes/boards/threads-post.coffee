"use strict"

joi = require "joi"
hapi = require "hapi"
boardApi = require "../../api/boards"
moment = require "moment"

paramsValidationSchema =
  board : joi.string().required()
  spot : joi.string().required()

payloadValidationSchema =
  message : joi.string().required()
  validThru: joi.number()
  meta : joi.object()

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
    data = 
      text : req.payload.message
      validThru : moment.utc(req.payload.validThru, "X").toDate()
      meta : req.payload.meta
    boardApi.createThread(user, spot, board, data).then (res) ->
      resp res
    , (err) ->
      resp hapi.Error.badRequest err