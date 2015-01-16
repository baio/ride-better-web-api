"use strict"

joi = require "joi"
hapi = require "hapi"
threadsApi = require "../../../api/threads"

paramsValidationSchema =
  threadId : joi.string().required()
  requestUserKey : joi.string().required()
  acceptFlag : joi.any(["accept", "reject"])

module.exports =
  method : "PUT"
  path : "/transfers/{threadId}/requests/{requestUserKey}/{acceptFlag}"
  config :
    validate :
      params : paramsValidationSchema
  handler : (req, resp) ->
    user = req.auth.credentials
    threadId = req.params.threadId
    requestUserKey = req.params.requestUserKey
    accept = if req.params.acceptFlag == "accept" then true else false
    threadsApi.acceptTransferRequest(user, threadId, requestUserKey, accept).then (res) ->
      resp res
    , (err) ->
      resp hapi.Error.badRequest err