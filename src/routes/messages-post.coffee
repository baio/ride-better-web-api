"use strict"
dailyMessagePost = require "../api/daily-message-post"
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
    dailyMessagePost(spot, data).then (res) ->
      resp res
    , (err) ->
      resp hapi.Error.badRequest err
