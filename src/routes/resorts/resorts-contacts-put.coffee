"use strict"

joi = require "joi"
resorts = require "../../data-access/mongo/resorts"
hapi = require "hapi"

paramsValidationSchema =
  spot : joi.string().required()

payloadValidationSchema =
  contacts : joi.array().includes(
    val :  joi.string().required()
    type : joi.string().allow(["phone", "site", "vk"]).required()
  )

module.exports =
  method : "PUT"
  path : "/resorts/{spot}/contacts"
  config :
    auth : false
    validate :
      params : paramsValidationSchema
      payload : payloadValidationSchema
  handler : (req, resp) ->
    resorts.putResortContacts(req.params.spot, req.payload.contacts).then (res) ->
      if !res
        resp hapi.Error.notFound()
      else
        resp res
    , (err) ->
        resp hapi.Error.badRequest err