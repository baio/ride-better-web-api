"use strict"

joi = require "joi"
resorts = require "../data-access/mongo/resorts"
hapi = require "hapi"

paramsValidationSchema =
  spot : joi.string().required()

module.exports =
  method : "GET"
  path : "/resorts/{spot}/info"
  config :
    auth : false
    validate :
      params : paramsValidationSchema
  handler : (req, resp) ->
    resorts.getResortInfo(req.params.spot).then (res) ->
      if !res
        resp hapi.Error.notFound()
      else      
        resp res
    , (err) ->
      resp hapi.Error.badRequest err
