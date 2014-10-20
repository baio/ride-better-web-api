catbox = require "catbox"
Q = require "q"

config = require("yaml-config").readConfig('./configs.yml', process.env.NODE_ENV)
host = config.mongo?.uri || process.env.MONGOLAB_URI
mongo = new catbox.Client require("catbox-mongodb"), config.catbox.mongo


mongoStart = Q.nbind mongo.start, mongo
mongoGet = Q.nbind mongo.get, mongo
mongoSet = Q.nbind mongo.set, mongo

mongoStart().then ->
    console.log "mongo-catbox start success"
  .fail (err) ->
    console.log "mongo-catbox start err", err

getKey = (id) ->
  segment: "chache"
  id: id

module.exports.get = (collection, id) ->
  mongoGet(getKey(collection + "_" + id)).then (res) ->
    if res then res.item else null

module.exports.set = (collection, id, val, ttl) ->
  mongoSet getKey(collection + "_" + id), val, ttl
