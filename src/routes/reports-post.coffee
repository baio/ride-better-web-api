"use strict"
reportsPost = require "../../api/reports-post"
hapi = require "hapi"
joi = require "joi"

paramsValidationSchema =
  spot : joi.string()

module.exports =
  method : "POST"
  path : "/reports/{spot}"
  config : validate : params : paramsValidationSchema
  handler : (req, resp) ->
    data = req.payload
    data.spot = req.params.spot
    data.user = req.auth.credentials
    reportsPost(data).then ->
      resp ok : true
    , (err) ->
      resp hapi.Error.badRequest err
