"use strict"

joi = require "joi"
snapshotApi = require "../../api/snapshot-get"
hapi = require "hapi"

paramsValidationSchema =
  spot : joi.string()

queryValidationSchema =
  lang : joi.any().valid(['ru', 'en'])

module.exports =
  method : "GET"
  path : "/snapshot/{spot}"
  config :
    auth : false
    validate :
      params : paramsValidationSchema
      query : queryValidationSchema
  handler : (req, resp) ->
    spot = req.params.spot
    snapshotApi(req.query.lang, spot).then (res) ->
      resp res
    , (err) ->
      stack = err.stack
      console.log stack
      if err.message == "Not Found"
        resp hapi.Error.notFound err
      else
        resp hapi.Error.badRequest err