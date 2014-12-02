webcams = require("./mongo").webcams
Promise = require "bluebird"
moment = require "moment"


map = (doc) ->
  if doc
    doc.created = moment.utc(doc.created).unix()
    doc.src = "https://dataavail.blob.core.windows.net/ride-better-webcams/" + doc.key
  doc

getOne = (q, s) ->
  s ?= created : -1
  cursor = webcams.find(q).sort(s).limit(1)
  Promise.promisify(cursor.toArray, cursor)().then (res) ->
    map res[0]

exports.getLatest = (spot) ->
  getOne spot : spot

exports.getNext = (spot, date) ->
  getOne {spot : spot, created : $gt : moment.utc(date + 1, "X").toDate()}, created : 1

exports.getPrev = (spot, date) ->
  getOne spot : spot, created : $lt : moment.utc(date, "X").toDate()