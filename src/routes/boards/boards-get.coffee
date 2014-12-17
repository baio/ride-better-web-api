"use strict"

joi = require "joi"
hapi = require "hapi"
boardApi = require "../../api/boards"

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
    boardApi.getBoard(spot, board).then (res) ->
      if !res
        resp spot : spot, title : board,  tags : [spot, board], threads : []
      else
        resp res
    , (err) ->
      resp hapi.Error.badRequest err