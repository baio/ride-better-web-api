"use strict"

joi = require "joi"
homeApi = require "../api/home-get"
hapi = require "hapi"

paramsValidationSchema =
  spot : joi.string()

queryValidationSchema =
  lang : joi.any().valid(['ru', 'en'])
  culture : joi.any().valid(['eu', 'uk', "us"])

module.exports =
  method : "GET"
  path : "/home/{spot}"
  config :
    auth : false
    validate :
      params : paramsValidationSchema
      query : queryValidationSchema
  handler : (req, resp) ->
    spot = req.params.spot
    lang = req.query.lang
    culture = req.query.culture
    homeApi(lang : lang, spot : spot, culture : culture).then (res) ->
      resp res
    , (err) ->
      if err.message == "Not Found"
        resp hapi.Error.notFound err
      else
        resp hapi.Error.badRequest err
