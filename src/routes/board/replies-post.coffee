"use strict"

joi = require "joi"
hapi = require "hapi"
threadsApi = require "../../api/threads"

paramsValidationSchema =
  threadId : joi.string().required()

payloadValidationSchema =
  message : joi.string().required()

module.exports =
  method : "POST"
  path : "/spots/boards/threads/{threadId}/replies"
  config :
    validate :
      params : paramsValidationSchema
      payload : payloadValidationSchema
  handler : (req, resp) ->
    user = req.auth.credentials
    threadId = req.params.threadId
    threadsApi.createReply(user, threadId, text : req.payload.message).then (res) ->
      resp res
    , (err) ->
      resp hapi.Error.badRequest err