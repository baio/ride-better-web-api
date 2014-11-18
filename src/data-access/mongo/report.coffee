reportModel = require "./models/report"
moment = require "moment"

exports.getLatest2Days = (spot) ->
  q =
    spot : spot
    time :  $gte : moment.utc().add(-2, "d").startOf("d").valueOf()
  reportModel.find(q).sort(time : -1).limit(25).exec()

exports.getCurrentYearLastClosedReport = (spot) ->
  q =
    spot : spot
    time : $gte : moment.utc().startOf("year").valueOf()
  reportModel.findOneAsync(q).then (res) -> res

exports.createReport = (data) ->
  report = new reportModel data
  if data.operate?.openDate
    report.set "operate.openDate.unix", data.operate.openDate
  report.saveAsync(report)
