"use strict"

joi = require "joi"
createResort = require "../../api/resorts-post"
hapi = require "hapi"

payloadValidationSchema =
  id : joi.string().required()
  title : joi.string().required()

module.exports =
  method : "POST"
  path : "/resorts"
  config :
    auth : false
    validate :
      payload : payloadValidationSchema
  handler : (req, resp) ->
    createResort(req.payload).then (res) ->
        resp res
    , (err) ->
        resp hapi.Error.badRequest err
