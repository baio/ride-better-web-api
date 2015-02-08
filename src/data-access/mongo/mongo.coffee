mongojs = require "mongojs"
Promise = require "bluebird"
config = require "../../config"

db = mongojs(config("MONGO_URI"), ["reports", "skimap", "resorts", "logs", "platforms"])

db.platforms.ensureIndex { platform : 1, token : 1 }, {unique : true}

exports.reports = Promise.promisifyAll db.reports
exports.resorts = Promise.promisifyAll db.resorts
exports.logs = Promise.promisifyAll db.logs
exports.platforms = Promise.promisifyAll db.platforms


