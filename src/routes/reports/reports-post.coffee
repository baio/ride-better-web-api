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
    spot = req.params.spot
    user = req.auth.credentials
    data = req.payload
    console.log ">>>reports-post.coffee:17", data
    reportsPost(user, spot, data).then ->
      resp ok : true
    , (err) ->
      resp hapi.Error.badRequest err
