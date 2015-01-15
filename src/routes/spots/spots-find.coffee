"use strict"

hapi = require "hapi"
joi = require "joi"
spotsGet = require "../../api/spots-find"

queryValidationSchema =
  #TODO : regex for geo
  geo : joi.string()
  term : joi.string().allow('')

module.exports =
  method : "GET"
  path : "/spots"
  config :
    auth : false
    validate : query : queryValidationSchema
  handler : (req, resp) ->
    if req.query.geo
      geo = req.query.geo.split(",").map (m) -> parseFloat m
    spotsGet(req.query.term, geo).then resp, (err) -> resp hapi.Error.badRequest err
