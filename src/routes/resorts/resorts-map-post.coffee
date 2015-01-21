"use strict"

joi = require "joi"
resorts = require "../../data-access/mongo/resorts"
storeFile = require "../helpers/store-file"
hapi = require "hapi"



paramsValidationSchema =
  spot : joi.string().required()

payloadValidationSchema =
  src : joi.string().regex(/(http|ftp|https):\/\/[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:\/~+#-]*[\w@?^=%&amp;\/~+#-])?/).required()

module.exports =
  method : "POST"
  path : "/resorts/{spot}/map"
  config :
    auth : false
    validate :
      params : paramsValidationSchema
      payload : payloadValidationSchema
  handler : (req, resp) ->
    spot = req.params.spot
    payload = req.payload
    storeFile.storeUrl("rb-map-#{spot}", "map", payload.src)
    .then (res) ->
      resorts.postResortMap(spot, src : res.url)
    .then (res) ->
      if !res
        resp hapi.Error.notFound()
      else
        resp res
    , (err) ->
        resp hapi.Error.badRequest err