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
  data :
    operate :
      type : Boolean
      default : true
    tracks :
      type : String
      enum : ["best", "good", "normal", "bad", "worst"]
    snowing :
      type : String
      enum : ["best", "good", "normal", "bad", "worst"]
    crowd :
      type : String
      enum : ["best", "good", "normal", "bad", "worst"]
    text :
      type : String

reportSchema.virtual("date.str").get( ->
  moment.utc(@date).format("YYYY-MM-DDTHH:mm:ss")
)

module.exports = mongoose.model("report", reportSchema)
