"use strict"

joi = require "joi"
webcams = require "../../data-access/webcams"
hapi = require "hapi"

paramsValidationSchema =
  spot : joi.string().required()
  index : joi.number().required()


module.exports =
  method : "GET"
  path : "/webcams/{spot}/{index}/latest"
  config :
    auth : false
    validate :
      params : paramsValidationSchema
  handler : (req, resp) ->
    webcams.getLatest(req.params.spot, req.params.index, req.params.index).then (res) ->
      if !res
        resp hapi.Error.notFound()
      else
        resp res
    , (err) ->
      resp hapi.Error.badRequest err
