"use strict"

joi = require "joi"
spots = require "../../data-access/mongo/spots"
hapi = require "hapi"

paramsValidationSchema =
  spot : joi.string().required()

module.exports =
  method : "GET"
  path : "/spots/{spot}"
  config :
    auth : false
    validate :
      params : paramsValidationSchema
  handler : (req, resp) ->
    spots.getSpot(req.params.spot).then (res) ->
      if !res
        resp hapi.Error.notFound()
      else
        resp res
    , (err) ->
      resp hapi.Error.badRequest err
