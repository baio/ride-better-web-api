catbox = require "catbox"
bluebird = require "bluebird"
config = require("yaml-config").readConfig('./configs.yml', process.env.NODE_ENV)
catboxCache = bluebird.promisifyAll new catbox.Client require("catbox-mongodb"), config.catbox.mongo

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
