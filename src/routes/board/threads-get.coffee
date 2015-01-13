"use strict"

joi = require "joi"
hapi = require "hapi"
threadsApi = require "../../api/threads"

paramsValidationSchema =
  board : joi.string()
  spot : joi.string().required()

queryValidationSchema =
  since : joi.number().allow("")
  till : joi.number().allow("")
  culture : joi.string().allow("")

module.exports =
  method : "GET"
  path : "/spots/{spot}/boards/{board?}"
  config :
    auth : false
    validate :
      params : paramsValidationSchema
      query : queryValidationSchema
  handler : (req, resp) ->
    query = req.query
    opts =
      culture : req.query.culture
    spot = req.params.spot
    board = req.params.board
    query = 
      since : query.since
      till : query.till
      spots : spot.split("-").filter (f) -> f
      boards :  if board then board.split("-").filter((f) -> f) else undefined
    threadsApi.getThreads(query, opts).then (res) ->
      resp if res then res else []
    , (err) ->
      resp hapi.Error.badRequest err