"use strict"

hapi = require "hapi"
joi = require "joi"
nearestSpotGet = require "../../api/nearest-spot-get"

queryValidationSchema =
#TODO : regex for geo
  geo : joi.string().required()

module.exports =
  method : "GET"
  path : "/nearest-spot"
  config :
    auth : false
    validate : query : queryValidationSchema
  handler : (req, resp) ->
    geo = req.query.geo.split(",").map (m) -> parseFloat m
    nearestSpotGet(geo).then resp, (err) -> resp hapi.Error.badRequest err
