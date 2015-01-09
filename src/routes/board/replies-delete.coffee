"use strict"

joi = require "joi"
hapi = require "hapi"
threadsApi = require "../../api/threads"

paramsValidationSchema =
  replyId : joi.string().required()

module.exports =
  method : "DELETE"
  path : "/spots/boards/threads/replies/{replyId}"
  config :
    validate :
      params : paramsValidationSchema
  handler : (req, resp) ->
    user = req.auth.credentials
    replyId = req.params.replyId
    threadsApi.removeReply(user, replyId).then (res) ->
      resp res
    , (err) ->
      resp hapi.Error.badRequest err