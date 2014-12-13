"use strict"

joi = require "joi"
hapi = require "hapi"
resorts = require "../../data-access/mongo/resorts"
Promise = require "bluebird"

azure = require "azure-storage"
fs = Promise.promisifyAll require "fs"
path = require "path"
blob = Promise.promisifyAll azure.createBlobService()

paramsValidationSchema =
  spot : joi.string().required()

module.exports =
  method : "PUT"
  path : "/resorts/{spot}/info/header"
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
      console.log spot, path
      key = "rb-resort-header-" + spot + path.extname(fileName)
      blob.createContainerIfNotExistsAsync("ride-better-resorts", publicAccessLevel : 'blob')
      .then ->
        blob.createBlockBlobFromLocalFileAsync("ride-better-resorts", key, filePath)
      .then ->
        headerUrl = "https://dataavail.blob.core.windows.net/ride-better-resorts/" + key
        resorts.putResortInfoHeader spot, headerUrl
      .then (res) ->
        resp res
      .error (err) ->
        resp hapi.Error.badRequest err
      .finally ->
        fs.unlinkAsync filePath


