mongo = require "./mongo"
moment = require "moment"

exports.createAd = (user, ad) ->
  ad._id = mongo.ObjectId()
  ad.created = moment.utc().toDate()
  mongo.orgs.updateAsync(
    { "user.key" : user.key },
    {
      $push : ads :  {$each : [ad], $position : 0}
    },
    upsert : false
  ).then (res) ->
    if res.ok and res.n == 1
      ad

exports.updateAd = (user, ad) ->
  q = { "ads._id" : mongo.ObjectId(ad._id), "user.key" : user.key}
  mongo.orgs.updateAsync(
    { "ads._id" : mongo.ObjectId(ad._id), "user.key" : user.key},
    {
      $set : "adds.$" : ad
    },
    upsert : false
  )

exports.removeAd = (user, adId) ->
  mongo.orgs.updateAsync(
    { "user.key" : user.key },
    {
      $pull : ads : _id : mongo.ObjectId(adId)
    }
    upsert : false
  )