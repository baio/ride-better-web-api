"use strict"
reportsGet = require "../../api/reports-get"
moment = require "moment"
hapi = require "hapi"
joi = require "joi"

paramsValidationSchema =
  spot : joi.string()

queryValidationSchema =
  lang : joi.any().allow(['ru'])

module.exports =
  method : "GET"
  path : "/reports/{spot}"
  config :
    auth : false
    validate :
      params : paramsValidationSchema
      query : queryValidationSchema
  handler : (req, resp) ->
    reportsGet(req.query.lang, req.params.spot).then resp, (err) ->
        resp hapi.Error.badRequest err
