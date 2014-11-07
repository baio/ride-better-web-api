"use strict"

hapi = require "hapi"
joi = require "joi"
spotsGet = require "../../api/spots-get"

queryValidationSchema =
  #TODO : regex for geo
  geo : joi.string()
  term : joi.string()

module.exports =
  method : "GET"
  path : "/spots"
  config :
    auth : false
    validate : query : queryValidationSchema
  handler : (req, resp) ->
    if req.query.geo
      geo = req.query.geo.split(",").map (m) -> parseFloat m
    console.log ">>>spots-get.coffee:21", geo
    spotsGet(geo, req.query.term).then resp, (err) -> resp hapi.Error.badRequest err
