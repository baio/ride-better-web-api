"use strict"

joi = require "joi"
hapi = require "hapi"
threadsApi = require "../../api/threads"
moment = require "moment"

paramsValidationSchema =
  board : joi.string().required()
  spot : joi.string().required()

payloadValidationSchema =
  message : joi.string().allow(['', null])
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
      validThru : moment.utc(req.payload.validThru, "X").toDate() if req.payload.validThru
      meta : req.payload.meta
    threadsApi.createThread(user, [spot, board], data).then (res) ->
      resp res
    , (err) ->
      resp hapi.Error.badRequest err