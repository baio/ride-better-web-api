mongojs = require "mongojs"
Promise = require "bluebird"
config = require "../../config"

db = mongojs(config("WEBCAMS_MONGO_URI"), ["webcams", "resorts"])

exports.resorts = Promise.promisifyAll db.resorts
exports.webcams = Promise.promisifyAll db.webcams



