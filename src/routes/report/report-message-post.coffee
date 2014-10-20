"use strict"
reportModel = require "../../models/report"
hapi = require "hapi"
joi = require "joi"

paramsValidationSchema =
  id : joi.string().token()

payloadValidationSchema =
  text : joi.string().min(3).max(150)

module.exports =
  method : "POST"
  path : "/report/{id}/message"
  config : validate :
    params : paramsValidationSchema
    payload : payloadValidationSchema
  handler : (req, resp) ->
    id = req.params.id
    message = req.payload.text
    user = req.auth.credentials
    reportModel.findOneAndUpdate {_id : id, "user.id" : user.id} , message : message, (err, doc) ->
      if err
        resp hapi.Error.badRequest err
      else if !doc
        resp hapi.Error.notFound()
      else
        resp ok : true