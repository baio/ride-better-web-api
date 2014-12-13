mongo = require "./mongo"
moment = require "moment"

exports.getResortInfo = (spot) ->
  mongo.resorts.findOneAsync({_id : spot}, {info  : 1, title : 1, geo : 1}).then (res) -> 
    if res
        spot : id : res._id, label : res.title
        info : res.info
        geo : res.geo

exports.getResortMaps = (spot) ->
  mongo.resorts.findOneAsync({_id : spot}, {maps  : 1, title : 1}).then (res) -> 
    if res
        spot : id : res._id, label : res.title
        maps : res.maps

exports.getResortPrices = (spot) ->
  mongo.resorts.findOneAsync({_id : spot}, {prices  : 1}).then (res) ->
    if res
        prices = res.prices
        if prices
          price.created = moment.utc(price.created).unix() for price in prices
        spot : id : res._id, label : res.title
        prices : prices
  	
exports.putResortInfoMain = (spot, data) ->
  mongo.resorts.findAndModifyAsync(
      query : {_id : spot}
      update : {$set  : {title : data.title, "info.description" : data.description, geo : data.geo} }
      upsert : false
    ).then (res) ->
    if res
      exports.getResortInfo(spot)
    
exports.putResortInfoHeader = (spot, headerUrl) ->
  mongo.resorts.findAndModifyAsync(
      query : {_id : spot}
      update : {$set  : {"info.header" : headerUrl} }
      upsert : false
    ).then (res) ->
    if res
      exports.getResortInfo(spot)
