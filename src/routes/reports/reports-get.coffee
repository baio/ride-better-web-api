"use strict"
reportsGet = require "../../api/reports-get"
moment = require "moment"
hapi = require "hapi"
joi = require "joi"

paramsValidationSchema =
  spot : joi.string()

module.exports =
  method : "GET"
  path : "/reports/{spot}"
  config :
    auth : false
    validate : params : paramsValidationSchema
  handler : (req, resp) ->
    reportsGet(req.params.spot).then resp, (err) ->
        resp hapi.Error.badRequest err
