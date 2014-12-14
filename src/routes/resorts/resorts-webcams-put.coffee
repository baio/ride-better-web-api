"use strict"

joi = require "joi"
resorts = require "../../data-access/mongo/resorts"
hapi = require "hapi"

paramsValidationSchema =
  spot : joi.string().required()

payloadValidationSchema =
  webcams : joi.array().includes(
    index :  joi.number().required()
    title :  joi.string().required()
    meta : joi.object(
      type : joi.string().allow(["stream"]).required()
      src : joi.string().regex(/(http|ftp|https):\/\/[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:\/~+#-]*[\w@?^=%&amp;\/~+#-])?/).required()
    )
  )

module.exports =
  method : "PUT"
  path : "/resorts/{spot}/webcams"
  config :
    auth : false
    validate :
      params : paramsValidationSchema
      payload : payloadValidationSchema
  handler : (req, resp) ->
    resorts.putResortWebcams(req.params.spot, req.payload.webcams).then (res) ->
      if !res
        resp hapi.Error.notFound()
      else
        resp res
    , (err) ->
        resp hapi.Error.badRequest err