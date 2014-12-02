mongojs = require "mongojs"
Promise = require "bluebird"
config = require "../../config"

db = mongojs(config("MONGO_URI"), ["ads", "orgs"])
db.orgs.ensureIndex( { "user.key" : 1 }, { unique: true } )

#ensure key on orgs.user.key

exports.ads = Promise.promisifyAll db.ads
exports.orgs = Promise.promisifyAll db.orgs
exports.ObjectId = mongojs.ObjectId


