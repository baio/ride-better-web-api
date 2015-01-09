"use strict"

joi = require "joi"
hapi = require "hapi"
threadsApi = require "../../api/threads"

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
    threadsApi.updateReply(user, replyId, text : req.payload.message).then (res) ->
      resp res
    , (err) ->
      resp hapi.Error.badRequest err