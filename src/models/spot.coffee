mongoose = require "mongoose"

spotSchema = mongoose.Schema
  _id : String
  name :
    type : String
    required : true
  location :
    country :
      code :
        type : String
        required : true
      name :
        type : String
        required : true
    region :
      name :
        type : String
        required : true
      code :
        type : String
        required : true
    city :
      name :
        type : String
        required : true
      code :
        type : String
        required : true
    geo :
      type : [Number]
      index : '2d'
    tz : String
  issuers : [
    name :
      type : String
      required : true
    code :
      type : String
      required : true
  ]

module.exports = mongoose.model("spot", spotSchema)
