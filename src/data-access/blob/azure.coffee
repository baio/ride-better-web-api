Promise = require "bluebird"
azure = require "azure-storage"
blob = Promise.promisifyAll azure.createBlobService()

exports.upload = (containerName, key, filePath) ->  
  blob.createContainerIfNotExistsAsync(containerName, publicAccessLevel : 'blob')
  .then ->
    blob.createBlockBlobFromLocalFileAsync(containerName, key, filePath)
  .then ->
    key : key
    url : "https://dataavail.blob.core.windows.net/#{containerName}/#{key}"
