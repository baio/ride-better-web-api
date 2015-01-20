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

transloaditPrms = 
  params : template_id : "39f8c160a00211e49a8635241991b365"

module.exports = (namePrefix, container, file) ->
  filePath =  file.path
  fileName = file.filename
  uname = filePath.substr(filePath.lastIndexOf('/') + 1)
  imageSize.sizeOfAsync(filePath).then (res) ->    
    key = "#{namePrefix}-#{uname}-#{res.width}x#{res.height}#{path.extname(fileName)}"
    transloadit.addFile(key, filePath)    
    transloadit.createAssemblyAsync(transloaditPrms)
  .then (res) ->
    console.log "store-file.coffee:26 >>>", res
    key = res.uploads[0].field
    tmpUrl = res.uploads[0].url
    key : key
    url : "http://rb-board.s3.amazonaws.com/thumbnail-" + key
    tmpUrl : tmpUrl
  .finally ->
    fs.unlinkAsync filePath


