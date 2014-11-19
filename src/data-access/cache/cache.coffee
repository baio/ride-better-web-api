catbox = require "catbox"
catboxMongo = require "catbox-mongodb"
Promise = require "bluebird"
config = require("../../config")
mongoURI = require "mongo-uri"

mongoParsedOpts = mongoURI.parse config("MONGO_URI")
mongoOpts =
  host : mongoParsedOpts.hosts[0]
  port : mongoParsedOpts.ports[0]
  username : mongoParsedOpts.username
  password : mongoParsedOpts.password
  partition : mongoParsedOpts.database

catboxCache = Promise.promisifyAll new catbox.Client catboxMongo, mongoOpts

catboxCache.startAsync().then ->
    console.log "mongo-catbox start success"
  .catch (err) ->
    console.log "mongo-catbox start err", err

getKey = (id) ->
  segment: "chache"
  id: id

exports.get = (collection, id) ->
  catboxCache.getAsync(getKey(collection + "_" + id)).then (res) ->
    if res then res.item else null

exports.set = (collection, id, val, ttl) ->
  catboxCache.setAsync(getKey(collection + "_" + id), val, ttl)

exports.remove = (collection, id) ->
  catboxCache.dropAsync(getKey(collection + "_" + id))
