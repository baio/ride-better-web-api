bluebird = require "bluebird"
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
  time :
    type : Date
    required : true
    default : Date.now
  spot :
    type : String
    required : true
  conditions :
    tracks :
      type : Number
    snowing :
      type : Number
    crowd :
      type : Number
  operate :
    status :
      type : String
      enum : ["open", "off-season", "day-off", "closed"]
    openDate : Date
  comment : String


reportSchema.virtual("time.unix").get( ->
  moment.utc(@time).unix()
)
reportSchema.virtual("operate.openDate.unix").get( ->
  if @operate.openDate
    moment.utc(@operate.openDate).unix()
).set((val) ->
  if val
    date = moment.utc(val, "X").toDate()
    utcDate = new Date Date.UTC date.getFullYear(), date.getMonth(), date.getDate()
    @operate.openDate = utcDate
)

module.exports = bluebird.promisifyAll mongoose.model("report", reportSchema)
