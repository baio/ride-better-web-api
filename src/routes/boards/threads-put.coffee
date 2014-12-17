"use strict"

joi = require "joi"
hapi = require "hapi"
boardApi = require "../../api/boards"

paramsValidationSchema =
  threadId : joi.string().required()

payloadValidationSchema =
  message : joi.string().required()

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
    boardApi.updateThread(user, threadId, req.payload.message).then (res) ->
      resp res
    , (err) ->
      resp hapi.Error.badRequest err