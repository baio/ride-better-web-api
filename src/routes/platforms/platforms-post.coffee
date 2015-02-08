"use strict"
platforms = require "../../data-access/mongo/platforms"
hapi = require "hapi"
joi = require "joi"

paramsValidationSchema =
  platform : joi.string().allow(["browser", "android", "ios", "wp8"]).required()
  token : joi.string().required()

module.exports =
  method : "POST"
  path : "/platforms/{platform}/{token}"
  config :
    auth : false
    validate : params : paramsValidationSchema
  handler : (req, resp) ->
    if req.params.platform == "browser"
      resp ok : true, message : "Skipped, browser not supported"
    else
      data =
        platform : req.params.platform
        token : req.params.token
      platforms.add(data).then ->
        resp ok : true
      , (err) ->
        if err.cause?.code == 11000
          resp ok : true, message : "Already registered"
        else
          resp hapi.Error.badRequest err
