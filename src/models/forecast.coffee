mongoose = require "mongoose"
moment = require("moment")

forecastConditionSchema = mongoose.Schema
  dateTime :
    type : Date
    required : true
  weather : String
  temperature :
    air : Number
    water : Number
  wind :
    direction :
      compass : String
      shore : String
    speed :
      steady : Number
      gusts : Number
  swell :
    period : Number
    height : Number
    direction :
      compass : String
      shore : String
  waves :
    height :
      min : Number
      max : Number
  custom : Object

forecastConditionSchema.virtual("dateTime.str").get( ->
  moment.utc(@dateTime).format("YYYY-MM-DDTHH:mm:ss")
).set((val) ->
  @dateTime = moment.utc(val, "YYYY-MM-DDTHH:mm:ss").toDate()
)

forecastSchema = mongoose.Schema
  spot :
    type: String
    ref: 'Spot'
  issuer :
    code :
      type : String
      required : true
      enum : ["msw", "wind-guru", "surf-guru", "surf-forecast"]
    datesRange :
      from : Date
      to : Date
    readDateTime :
      type : Date
      required : true
    issuerDateTime :
      type : Date
      required : true
    tz : String
  conditions : [ forecastConditionSchema ]

forecastSchema.virtual("issuer.datesRange.from.str").get( ->
      moment.utc(@issuer.datesRange.from).format("YYYY-MM-DDTHH:mm:ss")
  ).set((val) ->
  @issuer.datesRange.from = moment.utc(val, "YYYY-MM-DDTHH:mm:ss").toDate()
)

forecastSchema.virtual("issuer.datesRange.to.str").get( ->
  moment.utc(@issuer.datesRange.to).format("YYYY-MM-DD")
).set((val) ->
  @issuer.datesRange.to = moment.utc(val, "YYYY-MM-DD").toDate()
)

forecastSchema.virtual("issuer.readDateTime.str").get( ->
  moment.utc(@issuer.readDateTime).format("YYYY-MM-DDTHH:mm:ss")
).set((val) ->
  @issuer.readDateTime = moment.utc(val, "YYYY-MM-DDTHH:mm:ss").toDate()
)

forecastSchema.virtual("issuer.issuerDateTime.str").get( ->
  moment.utc(@issuer.issuerDateTime).format("YYYY-MM-DDTHH:mm:ss")
).set((val) ->
  @issuer.issuerDateTime = moment.utc(val, "YYYY-MM-DDTHH:mm:ss").toDate()
)

module.exports = mongoose.model("forecast", forecastSchema)