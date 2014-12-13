"use strict"

joi = require "joi"
resorts = require "../../data-access/mongo/resorts"
hapi = require "hapi"

paramsValidationSchema =
  spot : joi.string().required()

payloadValidationSchema =
  title : joi.string().required()
  description : joi.string().required()
  geo : joi.array().includes(joi.number()).length(2)

module.exports =
  method : "PUT"
  path : "/resorts/{spot}/info/main"
  config :
    auth : false
    validate :
      params : paramsValidationSchema
      payload : payloadValidationSchema
  handler : (req, resp) ->
    resorts.putResortInfoMain(req.params.spot, req.payload).then (res) ->
      if !res
        resp hapi.Error.notFound()
      else
        resp res
    , (err) ->
        resp hapi.Error.badRequest err
