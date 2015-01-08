"use strict"

joi = require "joi"
hapi = require "hapi"
boardApi = require "../../api/boards"
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
      console.log "threads-img-put.coffee:38 >>>", res
      msg =           
        text : data.message
        img : res.url
        validThru : moment.utc(data.validThru, "X").toDate() if data.validThru
        meta : data.meta
      boardApi.updateThread(user, threadId, msg)
    .then (res) ->
      resp res
    .error (err) ->
      resp hapi.Error.badRequest err

