"use strict"

joi = require "joi"
hapi = require "hapi"
boardApi = require "../../api/boards"

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
    boardApi.removeReply(user, replyId).then (res) ->
      resp res
    , (err) ->
      resp hapi.Error.badRequest err