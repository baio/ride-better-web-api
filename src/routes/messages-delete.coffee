"use strict"
dailyMessageDelete = require "../api/daily-message-delete"
hapi = require "hapi"
joi = require "joi"

paramsValidationSchema =
  id : joi.string()


module.exports =
  method : "DELETE"
  path : "/messages/{id}"
  config :
    validate :
      params : paramsValidationSchema
  handler : (req, resp) ->
    id = req.params.id
    dailyMessageDelete(id).then (res) ->
      resp res
    , (err) ->
      resp hapi.Error.badRequest err
