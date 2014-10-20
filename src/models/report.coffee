mongoose = require "mongoose"
moment = require "moment"

reportSchema = mongoose.Schema
  user :
    key :
      type : String
      required : true
    id :
      type : String
      required : true
    provider :
      type : String
      required : true
    name :
      type : String
      required : true
    avatar :
      type : String
  date :
    type : Date
    required : true
    default : Date.now
  spot :
    type : String
    required : true
  code :
    type : String
    required : true
    enum : ["no", "yes", "dunno"]
  message :
    type : String
    match : /^[.*]{3, 150}$/

reportSchema.virtual("date.str").get( ->
  moment.utc(@date).format("YYYY-MM-DDTHH:mm:ss")
)

module.exports = mongoose.model("report", reportSchema)
