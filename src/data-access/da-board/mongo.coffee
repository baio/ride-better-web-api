mongojs = require "mongojs"
Promise = require "bluebird"
_ = require "underscore"

config = require "../../config"
db = mongojs(config("MONGO_URI"), ["boards"])

exports.boards = Promise.promisifyAll db.boards
exports.ObjectId = mongojs.ObjectId
exports.pageSize = 25

exports.getBoardId = (tags) -> 
  tags = _.sortBy(tags)
  tags.join("-")

#exports.boards.ensureIndex({"tags" : 1}, {unique : true})


