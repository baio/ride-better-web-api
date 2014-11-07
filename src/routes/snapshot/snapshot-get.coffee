"use strict"

joi = require "joi"
snapshotApi = require "../../api/snapshot-get"
hapi = require "hapi"

paramsValidationSchema =
  spot : joi.string()

module.exports =
  method : "GET"
  path : "/snapshot/{spot}"
  config :
    auth : false
    validate : params : paramsValidationSchema
  handler : (req, resp) ->
    spot = req.params.spot
    snapshotApi(spot).then (res) ->
      resp res
    , (err) ->
      console.log ">>>snapshot-get.coffee:21", err
      if err.message == "Not Found"
        resp hapi.Error.notFound err
      else
        resp hapi.Error.badRequest err