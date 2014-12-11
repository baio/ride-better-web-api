mongo = require "./mongo"
moment = require "moment"

exports.getResortInfo = (spot) ->
  mongo.resorts.findOneAsync({_id : spot}, {info  : 1}).then (res) -> res?.info

exports.getResortMaps = (spot) ->
  mongo.resorts.findOneAsync({_id : spot}, {maps  : 1}).then (res) -> res?.maps

exports.getResortPrices = (spot) ->
  mongo.resorts.findOneAsync({_id : spot}, {prices  : 1}).then (res) ->
  	prices = res?.prices
  	if prices
  		price.created = moment.utc(price.created).unix() for price in prices
  		prices
  	

