mongojs = require "mongojs"
Promise = require "bluebird"
config = require "../../config"

db = mongojs(config("MONGO_URI"), ["boards"])

exports.boards = Promise.promisifyAll db.boards
exports.ObjectId = mongojs.ObjectId
exports.pageSize = 25


