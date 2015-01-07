"use strict"

joi = require "joi"
resorts = require "../../data-access/mongo/resorts"
hapi = require "hapi"

paramsValidationSchema =
  spot : joi.string().required()

payloadValidationSchema =
  prices : joi.array().includes(
    src :  joi.string().regex(/(http|ftp|https):\/\/[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:\/~+#-]*[\w@?^=%&amp;\/~+#-])?/).required()
    title : joi.string().required()
    created : joi.number().required()
    tag : joi.string().required()
    href : joi.string()
  )

module.exports =
  method : "PUT"
  path : "/resorts/{spot}/prices"
  config :
    auth : false
    validate :
      params : paramsValidationSchema
      payload : payloadValidationSchema
  handler : (req, resp) ->
    resorts.putResortPrices(req.params.spot, req.payload.prices).then (res) ->
      if !res
        resp hapi.Error.notFound()
      else
        resp res
    , (err) ->
        resp hapi.Error.badRequest err