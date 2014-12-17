"use strict"

joi = require "joi"
hapi = require "hapi"
threadApi = require "../../api/boards"

paramsValidationSchema =
  replyId : joi.string().required()

payloadValidationSchema =
  message : joi.string().required()

module.exports =
  method : "PUT"
  path : "/spots/boards/threads/replies/{replyId}"
  config :
    validate :
      params : paramsValidationSchema
      payload : payloadValidationSchema
  handler : (req, resp) ->
    user = req.auth.credentials
    replyId = req.params.replyId
    threadApi.updateThread(user, replyId, req.payload.message).then (res) ->
      resp res
    , (err) ->
      resp hapi.Error.badRequest err