mongo = require "./mongo"

getThread = (msg) ->
  msg.created = new Date()

  _id : mongo.ObjectId()
  message : msg

exports.getThread = getThread

exports.createThread = (boardId, msg) ->
  thread = getThread msg
  mongo.boards.updateAsync(
    {_id : mongo.ObjectId(boardId)},
    {$push : { threads : thread }},
    {save : true}
  ).then (res) ->
    if res.n == 0
      throw new Error "Board #{boardId} not found"
    else
      thread

exports.removeThread = (threadId, user) ->
  console.log ">>>thread.coffee:24", threadId, user
  mongo.boards.updateAsync(
    {"threads._id" : mongo.ObjectId(threadId), "threads.message._user" : user},
    {$pull : { threads : {_id : mongo.ObjectId(threadId)} }},
    {save : true}
  ).then (res) ->
    if res.n == 0
      throw new Error "Thread #{threadId} not found"
    else
      res

exports.addReply = (threadId, reply) ->
  replyId = mongo.ObjectId()
  reply._id = replyId
  reply.created = new Date()
  mongo.boards.updateAsync(
    {threads: { $elemMatch : { _id : mongo.ObjectId(threadId) } }},
    {$push : { "threads.$.replies" : {$each : [reply] , $position : 0} }},
    {save : true}
  ).then (res) ->
    if res.n == 0
      throw new Error "Thread #{threadId} not found"
    else
      replyId
