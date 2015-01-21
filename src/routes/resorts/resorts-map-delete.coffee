"use strict"

joi = require "joi"
resorts = require "../../data-access/mongo/resorts"
hapi = require "hapi"



paramsValidationSchema =
  spot : joi.string().required()
  src : joi.string().required()


module.exports =
  method : "DELETE"
  path : "/resorts/{spot}/maps/{src}"
  config :
    auth : false
    validate :
      params : paramsValidationSchema
  handler : (req, resp) ->
    spot = req.params.spot
    src = decodeURIComponent req.params.src
    resorts.deleteResortMap(spot, src)
    .then (res) ->
      if !res
        resp hapi.Error.notFound()
      else
        resp ok : true
    , (err) ->
        resp hapi.Error.badRequest err