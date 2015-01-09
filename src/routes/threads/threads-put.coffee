"use strict"

joi = require "joi"
hapi = require "hapi"
threadsApi = require "../../api/threads"
moment = require "moment"

paramsValidationSchema =
  threadId : joi.string().required()

payloadValidationSchema =
  message : joi.string().allow(['', null])
  img : joi.string().allow(['', null])
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
      img : req.payload.img
      validThru : moment.utc(req.payload.validThru, "X").toDate() if req.payload.validThru
      meta : req.payload.meta    
    threadsApi.updateThread(user, threadId, data).then (res) ->
      resp res
    , (err) ->
      resp hapi.Error.badRequest err