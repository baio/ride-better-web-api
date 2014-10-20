"use strict"
report = require "../../api/report-get"
moment = require "moment"
hapi = require "hapi"
joi = require "joi"

paramsValidationSchema =
  spot : joi.string()

module.exports =
  method : "GET"
  path : "/report/{spot}"
  config :
    auth : false
    validate : params : paramsValidationSchema
  handler : (req, resp) ->
    report(req.params.spot).then resp, (err) ->
      if err.message == "404"
        resp hapi.Error.notFound()
      else
        resp hapi.Error.badRequest err
