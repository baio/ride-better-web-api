"use strict"
dailyMessageGet = require "../api/daily-message-get"
hapi = require "hapi"
joi = require "joi"

paramsValidationSchema =
  spot : joi.string()

module.exports =
  method : "GET"
  path : "/spots/{spot}/messages"
  config :
    validate :
      params : paramsValidationSchema
  handler : (req, resp) ->
    spot = req.params.spot
    dailyMessageGet(spot).then (res) ->
      resp res
    , (err) ->
      resp hapi.Error.badRequest err
