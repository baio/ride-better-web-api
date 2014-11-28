mongo = require "./mongo"
moment = require "moment"
Promise = require "bluebird"

exports.getLatest = (spot) ->
  cursor = Promise.promisifyAll mongo.reports.find(spot : spot).sort(time : -1).limit(25)
  cursor.toArrayAsync()

exports.createReport = (data) ->
  if data.operate?.openDate
     data.operate.openDate = moment.utc(data.operate.openDate, "X").toDate()
  data.time = new Date()
  mongo.reports.insertAsync(data)