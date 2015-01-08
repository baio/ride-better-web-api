"use strict"

joi = require "joi"
blob = require "../../data-access/blob/azure"

Promise = require "bluebird"
fs = Promise.promisifyAll require "fs"
path = require "path"

module.exports = (namePrefix, container, file) ->
  filePath =  file.path
  fileName = file.filename
  uname = filePath.substr(filePath.lastIndexOf('/') + 1)
  key = namePrefix + "-" + uname + path.extname(fileName)
  blob.upload(container, key, filePath)
  .finally ->
    fs.unlinkAsync filePath


