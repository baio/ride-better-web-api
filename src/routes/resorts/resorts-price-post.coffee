"use strict"

joi = require "joi"
hapi = require "hapi"
resorts = require "../../data-access/mongo/resorts"
blob = require "../../data-access/blob/azure"

Promise = require "bluebird"
fs = Promise.promisifyAll require "fs"
path = require "path"

paramsValidationSchema =
  spot : joi.string().required()

module.exports =
  method : "POST"
  path : "/resorts/{spot}/price"
  config :
    auth : false
    validate :
      params : paramsValidationSchema
    payload: 
      output: 'file'
      parse: true
      uploads : "./tmp"
    handler : (req, resp) ->
      data = req.payload
      filePath =  data.file.path
      fileName = data.file.filename
      spot = req.params.spot
      uname = filePath.substr(filePath.lastIndexOf('/') + 1)
      key = "rb-resort-price-" + uname + path.extname(fileName)
      blob.upload("ride-better-resorts", key, filePath)
      .then (res) ->
        resorts.postResortPrice spot, {src : res.url, title : data.title}
      .then (res) ->
        resp res
      .error (err) ->
        resp hapi.Error.badRequest err
      .finally ->
        fs.unlinkAsync filePath


