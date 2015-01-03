"use strict"

joi = require "joi"
hapi = require "hapi"
boardApi = require "../../api/boards"
moment = require "moment"

paramsValidationSchema =
  threadId : joi.string().required()

payloadValidationSchema =
  message : joi.string().required()
  validThru: joi.number()
  meta : joi.object()

module.exports =
  method : "PUT"
  path : "/spots/boards/threads/{threadId}"
  config :
    validate :
      params : paramsValidationSchema
      payload : payloadValidationSchema
  handler : (req, resp) ->
    user = req.auth.credentials
    threadId = req.params.threadId
    data = 
      text : req.payload.message
      validThru : moment.utc(req.payload.validThru, "X").toDate()
      meta : req.payload.meta    
    boardApi.updateThread(user, threadId, data).then (res) ->
      resp res
    , (err) ->
      resp hapi.Error.badRequest err