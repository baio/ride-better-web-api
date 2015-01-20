"use strict"

joi = require "joi"
hapi = require "hapi"
resorts = require "../../data-access/mongo/resorts"
storeFile = require "../helpers/store-file"


paramsValidationSchema =
  spot : joi.string().required()

payloadValidationSchema =
  file :  joi.object()
  title : joi.string().required()
  tag : joi.string().required()
  href : joi.string()


module.exports =
  method : "POST"
  path : "/resorts/{spot}/price"
  config :
    auth : false
    validate :
      params : paramsValidationSchema
      payload : payloadValidationSchema
    payload:
      maxBytes: 524288000
      output: 'file'
      parse: true
      uploads : "./tmp"
    handler : (req, resp) ->
      data = req.payload
      spot = req.params.spot
      storeFile("rb-resort-price", "ride-better-resorts", data.file)
      .then (res) ->
        resorts.postResortPrice(spot, {src : res.url, title : data.title, tag : data.tag})
      .then (res) ->
        resp res
      .error (err) ->
        resp hapi.Error.badRequest err

