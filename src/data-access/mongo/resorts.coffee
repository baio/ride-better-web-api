mongo = require "./mongo"
moment = require "moment"

exports.postResort = (data) ->
  mongo.resorts.insertAsync(_id : data.id, title : data.title).then (res) ->
    if res
      exports.getResortInfo(data.id)

exports.putResortWebcams = (spot, webcams) ->
  mongo.resorts.findAndModifyAsync(
      query : {_id : spot}
      update : {$set  : {"webcams" : webcams} }
      upsert : false
    ).then (res) ->
      if res
        exports.getResortInfo(spot)

exports.putResortPrices = (spot, prices) ->
  mongo.resorts.findAndModifyAsync(
      query : {_id : spot}
      update : {$set  : {"prices" : prices} }
      upsert : false
    ).then (res) ->
      if res
        exports.getResortInfo(spot)

exports.postResortPrice = (spot, price) ->
  price.created = new Date()
  mongo.resorts.findAndModifyAsync(
      query : {_id : spot}
      update : $push : prices :  {$each : [price], $position : 0}
      upsert : false
  ).then (res) ->
    if res
      exports.getResortInfo(spot)

exports.getResortInfo = (spot) ->
  mongo.resorts.findOneAsync(_id : spot).then (res) ->
    if res.prices
      price.created = moment.utc(price.created).unix() for price in res.prices
    res.contacts = [] if ! res.contacts
    res.imgs = [] if ! res.imgs
    res.maps = [] if ! res.maps
    res.prices = [] if ! res.prices
    res.proscons = [] if ! res.proscons
    res

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
      update : {$set  : {title : data.title, description : data.description, geo : data.geo, header : data.header} }
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

exports.postResortMap = (spot, map) ->
  mongo.resorts.findAndModifyAsync(
      query : {_id : spot}
      update : { $push  : maps : map }
      upsert : false
    ).then (res) ->
      if res
        exports.getResortInfo(spot)

exports.deleteResortMap = (spot, src) ->
  mongo.resorts.findAndModifyAsync(
      query : {_id : spot}
      update : { $pull  : maps : src :  src}
    ).then (res) ->
      if res
        exports.getResortInfo(spot)
