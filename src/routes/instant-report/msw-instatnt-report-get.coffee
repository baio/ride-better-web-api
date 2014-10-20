"use strict"

report = require "../../api/msw-instant-reports-get"
hapi = require "hapi"
joi = require "joi"

paramsValidationSchema =
  spot: joi.string()

module.exports =
  method: "GET"
  path: "/instant-report/{spot}"
  config:
    auth : false
    validate:
      params: paramsValidationSchema
  handler: (req, resp) ->
    report(req.params.spot.split(",")).then resp, (err) ->
      if err.message == "404"
        resp hapi.Error.notFound()
      else
        resp hapi.Error.internal err


