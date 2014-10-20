"use strict"
forecastModel = require "../../models/forecast"
spotModel = require "../../models/spot"
hapi = require "hapi"
joi = require "joi"
moment = require "moment"
clone = require "cloneextend"
async = require "async"

paramsValidationSchema =
  spot : joi.string()
  date : joi.string().regex /^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/

module.exports =
  method : "GET"
  path : "/forecast/{spot}/{date}"
  config : validate : params : paramsValidationSchema
  handler : (req, resp) ->
    spot = req.params.spot
    dateStr = req.params.date
    date = moment.utc(dateStr, "YYYY-MM-DD")
    dateFrom = date.startOf("day")
    dateTo = moment(dateFrom).add(1, "d")
    async.parallel [
      (ck) -> spotModel.findOne {"_id" : spot}, ck
      (ck) ->
        q = forecastModel.find({"spot" : spot, "conditions.dateTime" : {$gte : dateFrom.toDate(), $lt : dateTo.toDate()}})
        q.sort("issuer.readDateTime" : 1)
        q.limit(1)
        q.exec ck
    ], (err, docs) ->
      spotDoc = docs[0]
      forecastDoc = docs[1][0]
      if err
        resp hapi.Error.badRequest err
      else if !spotDoc || !forecastDoc
        resp hapi.Error.notFound()
      else

        spot = spotDoc.toObject virtuals : true
        forecast = forecastDoc.toObject virtuals : true

        res = {}

        res.issuer =
          code : "surf-forecast"
          readDateTime : forecast.issuer.readDateTime.str
          issuerDateTime : forecast.issuer.issuerDateTime.str

        res.spot =
          code : spot._id
          name : spot.name
          label : spot.name + " (" + spot.location.city.name + ")"
          tz : spot.tz

        res.conditions = []

        for condition in forecast.conditions

          dt = moment.utc(condition.dateTime)

          if dt < dateFrom or dt > dateTo
            continue

          ctn =
            dateTime : condition.dateTime.str
            weather : condition.weather
            temperature : condition.temperature
            wind : condition.wind
            swell : condition.swell
            custom  : condition.custom

          ctn.swell.height = parseFloat(ctn.swell.height.toFixed(1)) if ctn.swell.height

          res.conditions.push ctn

        resp res