"use strict"
dailyMessagePost = require "../api/daily-message"
hapi = require "hapi"
joi = require "joi"

paramsValidationSchema =
  spot : joi.string()

payloadValidationSchema =
  message : joi.string().required()

module.exports =
  method : "POST"
  path : "/spots/{spot}/messages"
  config :
    validate :
      params : paramsValidationSchema
      payload : payloadValidationSchema
  handler : (req, resp) ->
    spot = req.params.spot
    data =
      user : req.auth.credentials
      message : req.payload.message
    dailyMessagePost(spot, data).then ->
      resp ok : true
    , (err) ->
      resp hapi.Error.badRequest err
