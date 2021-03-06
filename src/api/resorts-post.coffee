"use strict"

elastic = require "../data-access/elastic/spot"
mongo = require "../data-access/mongo/resorts"

module.exports = (data) ->
  mongo.postResort(data)
  .then (res) ->
    elastic.index(res._id, data).then -> res
    
