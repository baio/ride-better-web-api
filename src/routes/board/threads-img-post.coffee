"use strict"

joi = require "joi"
hapi = require "hapi"
threadsApi = require "../../api/threads"
moment = require "moment"
storeFile = require "../helpers/store-file"

paramsValidationSchema =
  board : joi.string().required()
  spot : joi.string().required()

payloadValidationSchema =
  message : joi.string().allow(['', null])
  validThru: joi.number()
  meta : joi.object()
  file : joi.object()

module.exports =
  method : "POST"
  path : "/spots/{spot}/boards/{board}/threads/img"
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
    spot = req.params.spot
    board = req.params.board
    storeFile("rb-message", "ride-better-messages", data.file)
    .then (res) ->
      msg =           
        text : req.payload.message
        img : res.url
        validThru : moment.utc(req.payload.validThru, "X").toDate() if req.payload.validThru
        meta : req.payload.meta
      threadsApi.createThread(user, {spot : spot, board : board}, msg)
    .then (res) ->
      resp res
    .error (err) ->
      resp hapi.Error.badRequest err

