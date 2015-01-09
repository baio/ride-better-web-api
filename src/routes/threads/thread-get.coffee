"use strict"

joi = require "joi"
hapi = require "hapi"
threadsApi = require "../../api/threads"

paramsValidationSchema =
  threadId : joi.string().required()

queryValidationSchema =
  since : joi.number().allow("")
  till : joi.number().allow("")

module.exports =
  method : "GET"
  path : "/spots/boards/threads/{threadId}"
  config :
    auth : false
    validate :
      params : paramsValidationSchema
      query : queryValidationSchema
  handler : (req, resp) ->
    threadId = req.params.threadId
    threadsApi.getThread(threadId).then (res) ->
      if res
        resp res
      else
        resp hapi.Error.notFound()  
    , (err) ->
      resp hapi.Error.badRequest err