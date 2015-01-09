mongo = require "./mongo"
moment = require "moment"

mapThread = (user, tags, data) ->
  tags : tags
  created : new Date()
  user : user
  replies : []
  data :
    text : data.text
    img : data.img
    validThru : moment.utc(data.validThru, "X").toDate() if data.validThru
    meta : data.meta

doc2thread = (doc) ->
  res = 
    _id : doc._id
    user : doc.user
    created : moment(doc.created).utc().unix()
    data : doc.data
    replies : (if doc.replies  then doc.replies else []).map doc2reply
  res.data.validThru = moment(doc.data.validThru).utc().unix() if doc.data.validThru
  res

doc2reply = (doc) ->
  user : doc.user
  message : doc.message
  created : moment(doc.created).utc().unix()

exports.createThread = (user, tags, msg) ->
  thread = mapThread user, tags, msg
  mongo.threads.insertAsync(thread).then (res) ->
    doc2thread res[0]

exports.getThreads = (tags, opts) ->
  mongo.threads.findAsync(tags : tags).then (res) ->
    res.map doc2thread

exports.updateThread = (user, threadId, data) ->
  thread = mapThread null, null, data
  mongo.threads.findAndModifyAsync(
    query : { _id : mongo.ObjectId(threadId), "user.key" : user.key }
    update : $set : data : thread.data
    new : true
    upsert : false
    fields : created : 1, user : 1, data : 1
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
  mongo.threads.findOneAsync(_id : threadId).then (res) ->
    doc2thread res

exports.createReply = (user, threadId, msg) ->
  reply = mapThread user, undefined, msg
  reply._id = mongo.ObjectId()
  mongo.threads.findAndModifyAsync(
    query : {_id : mongo.ObjectId(threadId), "user.key" : user.key}
    update : $push : replies : reply          
    new : false
    upsert : false
    fields : _id : 1
  ).then (res) ->
    if res.n == 0
      throw new Error "Thread #{threadId} not found"
    else
      doc2reply reply

exports.upadteReply = (user, replyId, msg) ->
  reply = mapThread user, undefined, msg
  mongo.threads.findAndModifyAsync(
    query : {"replies._id" : mongo.ObjectId(replyId), "user.key" : user.key}
    update : "replies.$.data" : $set : reply.data
    new : false
    upsert : false
    fields : _id : 1
  ).then (res) ->
    if res.n == 0
      throw new Error "Reply #{replyId} not found"
    else
      doc2reply reply

exports.removeReply = (user, replyId) ->
  mongo.threads.updateAsync(
    "replies._id" : mongo.ObjectId(replyId), "replies.user.key" : user.key
    $pull : replies : _id : mongo.ObjectId(replyId)
    save : true
  ).then (res) ->
    if res.n == 0
      throw new Error "Reply #{replyId} not found"
    else
      console.log "thread.coffee:83 >>>", res
      res