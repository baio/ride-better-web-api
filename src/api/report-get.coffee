"use strict"

reportModel = require "../models/report"
dtRange = require "./spot-date-time-range"
moment = require "moment-timezone"
Q = require "q"

module.exports = (spot) ->
  dtRange.getByCode(spot)
  .then (range) ->
      [range, Q(reportModel.find({"spot": spot, "date": {$gte: range.from, $lt: range.to}}, null, {sort : date: -1}).exec())]
  .spread (range, reports) ->
    dateRange : range
    items :
      reports.map (doc) ->
        m = doc.toObject virtuals: true
        id: m._id
        code: m.code
        spot: m.spot
        user: m.user
        date: moment.utc(m.date.str).tz(range.tz).format("YYYY-MM-DDTHH:mm:ss")
        message: m.message
