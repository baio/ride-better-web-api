"use strict"

config = require "../../config"
#blob = require "../../data-access/blob/azure"

Promise = require "bluebird"
fs = Promise.promisifyAll require "fs"
imageSize = Promise.promisifyAll sizeOf : require "image-size"
path = require "path"

TransloaditClient = require('transloadit')
transloadit = Promise.promisifyAll new TransloaditClient
  authKey    : config("TRANSLOADIT_KEY")
  authSecret : config("TRANSLOADIT_SECRET")

transloaditPrms = params : template_id : null

templatesList = 
  board : "39f8c160a00211e49a8635241991b365"
  header : "60466540a0d211e4bf90872d7005f5da"
  price : "39f8c160a00211e49a8635241991b365"
  map : "39f8c160a00211e49a8635241991b365"

module.exports = (namePrefix, template, file) ->
  filePath =  file.path
  fileName = file.filename
  uname = filePath.substr(filePath.lastIndexOf('/') + 1)
  imageSize.sizeOfAsync(filePath).then (res) ->    
    transloaditPrms.params.template_id = templatesList[template]
    key = "#{namePrefix}-#{uname}-#{res.width}x#{res.height}#{path.extname(fileName)}"
    transloadit.addFile(key, filePath)        
    transloadit.createAssemblyAsync(transloaditPrms)
  .then (res) ->
    key = res.uploads[0].field
    tmpUrl = res.uploads[0].url
    key : key
    url : "http://rb-#{template}.s3.amazonaws.com/thumbnail-" + key
    tmpUrl : tmpUrl
  .finally ->
    fs.unlinkAsync filePath


