"use strict"
Q = require "Q"
reportModel = require "../models/report"
moment = require "moment"

module.exports = (spot) ->
  dateFrom = moment.utc().add(-2, "d").toDate()
  q =
    spot : spot
    date : $gte : dateFrom
  Q(reportModel.find(q).sort(date : 1).limit(25).exec()).then (res) ->
    res.map (m) ->
      r = m.toObject()
      delete r._id
      delete r.__v
      user : r.user
      conditions : r.data
      time : r.date
      operate : r.data.operate
