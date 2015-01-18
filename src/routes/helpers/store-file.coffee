"use strict"

joi = require "joi"
blob = require "../../data-access/blob/azure"


Promise = require "bluebird"
fs = Promise.promisifyAll require "fs"
imageSize = Promise.promisifyAll sizeOf : require "image-size"
path = require "path"

module.exports = (namePrefix, container, file) ->
  filePath =  file.path
  fileName = file.filename
  uname = filePath.substr(filePath.lastIndexOf('/') + 1)
  imageSize.sizeOfAsync(filePath).then (res) ->    
    key = "#{namePrefix}-#{uname}-#{res.width}x#{res.height}#{path.extname(fileName)}"
    blob.upload(container, key, filePath)  
  .finally ->
    fs.unlinkAsync filePath


