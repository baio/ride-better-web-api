"use strict"

joi = require "joi"
updateResort = require "../../api/resorts-put"
hapi = require "hapi"

paramsValidationSchema =
  spot : joi.string().required()

payloadValidationSchema =
  title : joi.string().required()
  description : joi.string().required()
  geo : joi.array().includes(joi.number()).length(2)

module.exports =
  method : "PUT"
  path : "/resorts/{spot}/info"
  config :
    auth : false
    validate :
      params : paramsValidationSchema
      payload : payloadValidationSchema
  handler : (req, resp) ->
    updateResort(req.params.spot, req.payload).then (res) ->
      if !res
        resp hapi.Error.notFound()
      else
        resp res
    , (err) ->
        resp hapi.Error.badRequest err
