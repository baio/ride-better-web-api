mongojs = require "mongojs"
Promise = require "bluebird"
_ = require "underscore"

config = require "../../config"
db = mongojs(config("MONGO_URI"), ["ths"])

exports.threads = Promise.promisifyAll db.ths
exports.ObjectId = mongojs.ObjectId
exports.pageSize = 25

exports.threads.ensureIndex({"tags" : 1})

exports.find = (coll, query, order) -> 
  Promise.promisifyAll(db[coll].find(query).sort(order).limit(exports.pageSize)).toArrayAsync()

