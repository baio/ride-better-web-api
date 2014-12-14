mongo = require "./mongo"
moment = require "moment"

exports.getResortInfo = (spot) ->
  mongo.resorts.findOneAsync(_id : spot)

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
      update : {$set  : {title : data.title, description : data.description, geo : data.geo} }
      upsert : false
    ).then (res) ->
    if res
      exports.getResortInfo(spot)
    
exports.putResortInfoHeader = (spot, headerUrl) ->
  mongo.resorts.findAndModifyAsync(
      query : {_id : spot}
      update : {$set  : {"header" : headerUrl} }
      upsert : false
    ).then (res) ->
    if res
      exports.getResortInfo(spot)

exports.putResortContacts = (spot, contacts) ->
  mongo.resorts.findAndModifyAsync(
      query : {_id : spot}
      update : {$set  : {"contacts" : contacts} }
      upsert : false
    ).then (res) ->
    if res
      exports.getResortInfo(spot)

exports.putResortProsCons = (spot, proscons) ->
  mongo.resorts.findAndModifyAsync(
      query : {_id : spot}
      update : {$set  : {"proscons" : proscons} }
      upsert : false
    ).then (res) ->
    if res
      exports.getResortInfo(spot)

exports.putResortMaps = (spot, maps) ->
  mongo.resorts.findAndModifyAsync(
      query : {_id : spot}
      update : {$set  : {"maps" : maps} }
      upsert : false
    ).then (res) ->
    if res
      exports.getResortInfo(spot)
