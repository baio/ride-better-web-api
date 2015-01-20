"use strict"

joi = require "joi"
updateResort = require "../../api/resorts-put"
storeFile = require "../helpers/store-file"
hapi = require "hapi"
Promise = require "bluebird"

paramsValidationSchema =
  spot : joi.string().required()

payloadValidationSchema =
  title : joi.string().required()
  file : joi.object()
  header : joi.string()
  description : joi.string().required()
  geo : joi.array().includes(joi.number()).length(2)  

module.exports =
  method : "PUT"
  path : "/resorts/{spot}/info"
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
    user = req.auth.credentials
    spot = req.params.spot
    payload = req.payload
    threadId = req.params.threadId
    if payload.file
      promise = storeFile("rb-spot-header-#{spot}", "header", payload.file)
    else
      promise = Promise.resolve()
    promise.then (res) ->      
      delete payload.file      
      payload.header = res.url if res
      updateResort(spot, payload).then (res1) ->
        if res1
          res1.tmpHeader = res?.tmpUrl
          res1
    .then (res) ->
      if !res
        resp hapi.Error.notFound()
      else
        resp res
    , (err) ->
        resp hapi.Error.badRequest err
