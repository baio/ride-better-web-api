mongo = require "./mongo"

module.exports.write = (data) ->
  
  ###
  data :
    spot : spot
    tag : tag
    doc : 
      _id : record id
      coll : collection name
      user : user
      oper : oper
      comment : comment
      img : img
  ###
  data.created = new Date()
  mongo.logs.insertAsync(data)

module.exports.get = (sinceId) ->  
  q = _id : $lt : sinceId if sinceId
  mongo.logs.findAsync(q).then (res) ->
    res.created = moment.utc(res.created).unix() for r in res
    res
