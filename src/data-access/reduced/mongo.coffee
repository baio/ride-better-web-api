mongojs = require "mongojs"
Promise = require "bluebird"
config = require "../../config"

db = mongojs(config("REDUCED_MONGO_URI"), ["fhist_reduced"])

exports.fhist = Promise.promisifyAll db.fhist_reduced


