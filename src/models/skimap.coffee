mongoose = require "mongoose"

skimapSchema = mongoose.Schema
  id :
    type: String
    require: true
  longitude : Number
  latitude : Number

module.exports = mongoose.model("skimap", skimapSchema, "skimap")