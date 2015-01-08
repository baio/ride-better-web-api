mongojs = require "mongojs"
Promise = require "bluebird"
config = require "../../config"

db = mongojs(config("MONGO_URI"), ["reports", "skimap", "resorts", "logs"])

exports.reports = Promise.promisifyAll db.reports
exports.resorts = Promise.promisifyAll db.resorts
exports.logs = Promise.promisifyAll db.logs


