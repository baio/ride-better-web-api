"use strict"

spotModel = require "../models/spot"
moment = require "moment-timezone"
Q = require "q"

get = (spotDoc) ->
  exact = moment.utc().tz(spotDoc.location.tz)
  dateFrom = moment.utc [exact.year(), exact.month(), exact.date()]
  dateTo = moment(dateFrom).add(1, "d")
  from : dateFrom.toDate()
  to : dateTo.toDate()
  exact : moment.utc [exact.year(), exact.month(), exact.date(), exact.hour(), exact.minute()]
  tz : spotDoc.location.tz


getByCode = (spot) ->
  Q(spotModel.findOne({"_id" : spot}, {"location.tz" : 1}).exec()).then (spotDoc) ->
    if !spotDoc
      throw new Error "404"
    else
      get spotDoc


module.exports.get = get
module.exports.getByCode = getByCode