"use strict"

joi = require "joi"
hapi = require "hapi"
threadsApi = require "../../../api/threads"

paramsValidationSchema =
  threadId : joi.string().required()

module.exports =
  method : "POST"
  path : "/transfers/{threadId}/request"
  config :
    validate :
      params : paramsValidationSchema
  handler : (req, resp) ->
    user = req.auth.credentials
    threadId = req.params.threadId
    threadsApi.createTransferRequest(user, threadId).then (res) ->
      resp res
    , (err) ->
      resp hapi.Error.badRequest err