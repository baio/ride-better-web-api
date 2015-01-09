"use strict"

joi = require "joi"
hapi = require "hapi"
threadsApi = require "../../api/threads"

paramsValidationSchema =
  board : joi.string().required()
  spot : joi.string().required()

queryValidationSchema =
  since : joi.number().allow("")
  till : joi.number().allow("")

module.exports =
  method : "GET"
  path : "/spots/{spot}/boards/{board}"
  config :
    auth : false
    validate :
      params : paramsValidationSchema
      query : queryValidationSchema
  handler : (req, resp) ->
    spot = req.params.spot
    board = req.params.board
    threadsApi.getThreads([spot, board]).then (res) ->
      resp if res then res else []
    , (err) ->
      resp hapi.Error.badRequest err