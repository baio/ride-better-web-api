mongojs = require "mongojs"
Promise = require "bluebird"
config = require "../../config"

db = mongojs(config("MONGO_URI"), ["ads", "orgs"])

exports.ads = Promise.promisifyAll db.ads
exports.orgs = Promise.promisifyAll db.orgs


