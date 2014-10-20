"use strict"
reportModel = require "../../models/report"
hapi = require "hapi"
joi = require "joi"
reportGet = require "../../api/short-report-get"

paramsValidationSchema =
  spot : joi.string()
  code : joi.string().regex /^no|yes|dunno$/

module.exports =
  method : "POST"
  path : "/report/{spot}/{code}"
  config : validate : params : paramsValidationSchema
  handler : (req, resp) ->
    spot = req.params.spot
    code = req.params.code
    user = req.auth.credentials
    report = new reportModel user : user, spot : spot, code : code
    report.save (err) ->
      if err
        resp hapi.Error.badRequest err
      else
        reportGet(spot).then (res) ->
          resp id : report._id, report : res
        .fail resp
