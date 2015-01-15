"use strict"

hapi = require "hapi"
joi = require "joi"
nearestSpotsGet = require "../../api/nearest-spots-get"

queryValidationSchema =
#TODO : regex for geo
  geo : joi.string().required()

module.exports =
  method : "GET"
  path : "/nearest-spots"
  config :
    auth : false
    validate : query : queryValidationSchema
  handler : (req, resp) ->
    geo = req.query.geo.split(",").map (m) -> parseFloat m
    nearestSpotsGet(geo).then resp, (err) -> resp hapi.Error.badRequest err
