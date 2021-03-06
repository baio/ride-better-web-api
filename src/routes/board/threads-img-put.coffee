"use strict"

joi = require "joi"
hapi = require "hapi"
threadsApi = require "../../api/threads"
moment = require "moment"
storeFile = require "../helpers/store-file"

paramsValidationSchema =
  threadId : joi.string().required()

payloadValidationSchema =
  message : joi.string().allow(['', null])
  validThru: joi.number()
  meta : joi.object()
  file : joi.object()

module.exports =
  method : "PUT"
  path : "/spots/boards/threads/{threadId}/img"
  config :
    validate :
      params : paramsValidationSchema
      payload : payloadValidationSchema
    payload:
      maxBytes: 524288000
      output: 'file'
      parse: true
      uploads : "./tmp"
  handler : (req, resp) ->
    user = req.auth.credentials
    data = req.payload
    threadId = req.params.threadId
    storeFile("rb-message", "ride-better-messages", data.file)
    .then (res) ->
      msg =           
        text : data.message
        img : res.url
        validThru : moment.utc(data.validThru, "X").toDate() if data.validThru
        meta : data.meta
      threadsApi.updateThread(user, threadId, msg).then (res1) ->
        res1.tmpImg = res.tmpUrl
        res1  
    .then (res) ->
      resp res
    .error (err) ->
      resp hapi.Error.badRequest err

