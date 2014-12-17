"use strict"
dailyMessageGet = require "../api/daily-message-get"
hapi = require "hapi"
joi = require "joi"

paramsValidationSchema =
  spot : joi.string()

queryValidationSchema =
  since : joi.number().allow("")
  till : joi.number().allow("")


module.exports =
  method : "GET"
  path : "/spots/{spot}/messages"
  config :
    auth : false
    validate :
      params : paramsValidationSchema
      query : queryValidationSchema
  handler : (req, resp) ->
    spot = req.params.spot
    dailyMessageGet(spot, req.query).then (res) ->
      resp res
    , (err) ->
      resp hapi.Error.badRequest err
