mongo = require "./mongo"
moment = require "moment"

mapThread = (user, tags, data) ->
  tags : tags
  created : new Date()
  user : user
  spot : data.spot
  replies : []  
  data :
    text : data.text
    img : data.img
    validThru : moment.utc(data.validThru, "X").toDate() if data.validThru
    meta : data.meta

mapReply = (user, data) ->    
  created : new Date()
  user : user
  data :
    text : data.text


doc2thread = (doc) ->
  res = 
    _id : doc._id
    tags : doc.tags
    user : doc.user
    spot : doc.spot
    created : moment(doc.created).utc().unix()
    data : doc.data
    replies : (if doc.replies then doc.replies else []).map doc2reply
  if doc.tags.indexOf("transfer") != -1
    res.requests = if doc.requests then doc.requests else []
  res.data.validThru = moment(doc.data.validThru).utc().unix() if doc.data.validThru
  res

doc2reply = (doc) ->
  _id : doc._id
  user : doc.user
  created : moment(doc.created).utc().unix()
  data : doc.data

exports.createThread = (user, prms, msg) ->
  thread = mapThread user, [prms.spot, prms.board], msg
  mongo.threads.insertAsync(thread).then (res) ->
    doc2thread res[0]

###
since : query.since
till : query.till
spots : spot.split("-")
priority
boards :  board
###
exports.getThreads = (q) ->
  since = moment.utc(q.since, "X").toDate() if q?.since
  till = moment.utc(q.till + 1, "X").toDate() if q?.till

  query = {}
  spotTags = []

  #console.log "threads.coffee:56 >>>", q

  query = $and : []

  if q.boards
    query.$and.push tags : $in : q.boards
  if q.spots.length
    query.$and.push tags : $in : q.spots        
  if since 
    query.$and.push created : $lt : since
  if till
    query.$and.push created : $gt : till
  if q.priority
    query.$and.push "data.meta.priority" : q.priority

  #console.log "threads.coffee:72 >>>", query.$and[0], query.$and[1]

  query = undefined if !query.$and.length 

  mongo.find("ths", query, created : -1).then (res) ->
    res.map doc2thread

exports.updateThread = (user, threadId, data) ->
  thread = mapThread null, null, data
  mongo.threads.findAndModifyAsync(
    query : { _id : mongo.ObjectId(threadId), "user.key" : user.key }
    update : $set : data : thread.data
    new : true
    upsert : false
    fields : created : 1, user : 1, data : 1, replies : 1, tags : 1
  ).then (res) ->    
    if !res[0]
      throw new Error "Thread #{threadId} not found"
    else
      doc2thread res[0]

exports.removeThread = (user, threadId) ->
  mongo.threads.removeAsync(
    _id : mongo.ObjectId(threadId), "user.key" : user.key
  ).then (res) ->
    console.log "thread.coffee:83 >>>", res
    res

exports.getThread = (threadId, opts) ->
  mongo.threads.findOneAsync(_id : mongo.ObjectId(threadId)).then (res) ->
    doc2thread res

exports.getLatestImportantMessages = (spot) ->
  query = tags : [spot, "message"], "data.meta.priority" : "important"
  mongo.find("ths", query, created : -1, 5).then (res) ->
    res.map doc2thread    

exports.createReply = (user, threadId, msg) ->
  reply = mapReply user, msg
  reply._id = mongo.ObjectId()
  mongo.threads.findAndModifyAsync(
    query : {_id : mongo.ObjectId(threadId)}
    update : $push : replies : reply          
    new : false
    upsert : false
    fields : _id : 1
  ).then (res) ->
    if res.n == 0
      throw new Error "Thread #{threadId} not found"
    else
      doc2reply reply

exports.updateReply = (user, replyId, msg) ->
  reply = mapReply user, msg
  mongo.threads.findAndModifyAsync(
    query : {"replies._id" : mongo.ObjectId(replyId), "user.key" : user.key}
    update : $set : "replies.$.data" :  reply.data
    new : true
    upsert : false
  ).then (res) ->
    console.log "threads.coffee:138 >>>", res
    if res.n == 0
      throw new Error "Reply #{replyId} not found"
    else
      doc2reply reply

exports.removeReply = (user, replyId) ->
  mongo.threads.updateAsync(
    { "replies._id" : mongo.ObjectId(replyId), "replies.user.key" : user.key},
    {$pull : replies : _id : mongo.ObjectId(replyId)},
    {save : true}
  ).then (res) ->
    if res.n == 0
      throw new Error "Reply #{replyId} not found"
    else
      res

exports.createTransferRequest = (user, threadId) ->      
  console.log "threads.coffee:144 >>>", user, threadId
  mongo.threads.updateAsync(
    { "_id" : mongo.ObjectId(threadId), "requests.user.key" : {"$ne" : user.key}},
    {$push : {requests : { user : user }}},
    {save : true, upsert : true}
  ).then (res) ->
    if res.n == 0
      throw new Error "Transfer #{threadId} not found"
    else
      user : user

exports.removeTransferRequest = (user, threadId) ->      
  mongo.threads.updateAsync(
    { "_id" : mongo.ObjectId(threadId) },
    {$pull : requests : {"user.key" : user.key}},
    {save : true}
  ).then (res) ->
    if res.n == 0
      throw new Error "Transfer #{threadId} not found"
    else
      user : user

exports.acceptTransferRequest = (user, threadId, requestUserKey, isAccept) ->      
  mongo.threads.updateAsync(
    { "_id" : mongo.ObjectId(threadId), "user.key" : user.key, "requests.user.key" : requestUserKey},
    {$set : "requests.$.accepted" : isAccept },
    {save : true}
  ).then (res) ->
    if res.n == 0
      throw new Error "Transfer #{threadId} not found"
    else
      res

