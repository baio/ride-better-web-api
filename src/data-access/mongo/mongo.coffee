mongojs = require "mongojs"
Promise = require "bluebird"
config = require "../../config"

db = mongojs(config("MONGO_URI"), ["reports", "skimap", "resorts"])

exports.reports = Promise.promisifyAll db.reports
exports.resorts = Promise.promisifyAll db.resorts


