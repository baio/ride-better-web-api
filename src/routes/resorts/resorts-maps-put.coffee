"use strict"

joi = require "joi"
resorts = require "../../data-access/mongo/resorts"
hapi = require "hapi"



paramsValidationSchema =
  spot : joi.string().required()

payloadValidationSchema =
  maps : joi.array().includes(
    src :  joi.string().regex(/(http|ftp|https):\/\/[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:\/~+#-]*[\w@?^=%&amp;\/~+#-])?/).required()
  )

module.exports =
  method : "PUT"
  path : "/resorts/{spot}/maps"
  config :
    auth : false
    validate :
      params : paramsValidationSchema
      payload : payloadValidationSchema
  handler : (req, resp) ->
    resorts.putResortMaps(req.params.spot, req.payload.maps).then (res) ->
      if !res
        resp hapi.Error.notFound()
      else
        resp res
    , (err) ->
        resp hapi.Error.badRequest err