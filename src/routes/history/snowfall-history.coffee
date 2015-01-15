"use strict"

joi = require "joi"
hapi = require "hapi"
snowfallHistory = require "../../api/snowfall-history"


paramsValidationSchema =
  spots : joi.string().required()

module.exports =
  method : "GET"
  path : "/spots/{spots}/snowfall-history"
  config :
    auth : false
    validate :
      params : paramsValidationSchema
  handler : (req, resp) ->
    spots = req.params.spots.split "-"
    snowfallHistory.getHist(spots).then (res) ->
      resp res
    , (err) ->
      resp hapi.Error.badRequest err
