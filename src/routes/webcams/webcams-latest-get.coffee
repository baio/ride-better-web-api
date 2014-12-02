"use strict"

joi = require "joi"
webcams = require "../../data-access/webcams"
hapi = require "hapi"

paramsValidationSchema =
  spot : joi.string().required()


module.exports =
  method : "GET"
  path : "/webcams/{spot}/latest"
  config :
    auth : false
    validate :
      params : paramsValidationSchema
  handler : (req, resp) ->
    webcams.getLatest(req.params.spot).then (res) ->
      if !res
        resp hapi.Error.notFound()
      else
        resp res
    , (err) ->
      resp hapi.Error.badRequest err
