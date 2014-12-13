"use strict"

joi = require "joi"
resorts = require "../../data-access/mongo/resorts"
hapi = require "hapi"

paramsValidationSchema =
  spot : joi.string().required()

payloadValidationSchema =
  proscons : 
    pros : joi.array().includes(joi.string().required())
    cons : joi.array().includes(joi.string().required())

module.exports =
  method : "PUT"
  path : "/resorts/{spot}/proscons"
  config :
    auth : false
    validate :
      params : paramsValidationSchema
      payload : payloadValidationSchema
  handler : (req, resp) ->
    resorts.putResortProsCons(req.params.spot, req.payload.proscons).then (res) ->
      if !res
        resp hapi.Error.notFound()
      else
        resp res
    , (err) ->
        resp hapi.Error.badRequest err