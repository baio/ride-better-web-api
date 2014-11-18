mongoose = require "mongoose"
bluebird = require "bluebird"

skimapSchema = mongoose.Schema
  id :
    type: String
    require: true
  longitude : Number
  latitude : Number

module.exports = bluebird.promisifyAll mongoose.model("skimap", skimapSchema, "skimap")