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
      payload = req.payload
      spot = req.params.spot
      storeFile("rb-price-#{spot}", "price", payload.file)
      .then (res) ->
        resorts.postResortPrice(spot, {src : res.url, title : payload.title, tag : payload.tag, href : payload.href}).then (res1) ->
          res1.tmpSrc = res.tmpUrl
          res1
      .then (res) ->
        resp res
      .error (err) ->
        resp hapi.Error.badRequest err

