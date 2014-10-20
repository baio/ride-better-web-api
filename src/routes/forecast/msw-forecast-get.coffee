"use strict"
mswForecast = require "../../api/msw-forecast-get"
hapi = require "hapi"
joi = require "joi"
moment = require "moment"

paramsValidationSchema =
  spot: joi.string()
  #date: joi.string().regex /^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/

module.exports =
  method: "GET"
  path: "/forecast/{spot}"
  config:
    auth : false
    validate:
      params: paramsValidationSchema
  handler: (req, resp) ->
    mswForecast(req.params.spot).then resp, (err) ->
        if err.message == "404"
          resp hapi.Error.notFound()
        else
          resp hapi.Error.badRequest err


