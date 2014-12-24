mongo = require "./mongo"
moment = require "moment"

mapThread = (user, msg) ->
  _id : mongo.ObjectId()
  created : new Date()
  user : user
  text : msg
  replies : []

exports.mapThread = mapThread

exports.createThread = (user, tags, msg) ->
  boardId = mongo.getBoardId(tags)
  thread = mapThread user, msg
  mongo.boards.updateAsync(
    {_id : boardId}
    {$push : { threads : thread }}
  ).then (res) ->
    if res.n == 0
      throw new Error "Board #{boardId} not found"
    else
      thread

exports.getThread = (threadId, opts) ->
  since = moment.utc(opts.since, "X").toDate() if opts?.since
  till = moment.utc(opts.till + 1, "X").toDate() if opts?.till
  query = {}
  query.$lt = since if since
  query.$gt = till if till
  if query.$lt or query.$gt
    query = "threads.replies.created" : query
  mongo.boards.aggregateAsync(
    [
      {$match : { "threads._id" : mongo.ObjectId threadId}},
      {$unwind : "$threads"},
      {$unwind : "$threads.replies"},
      {$match : if query then query else {}},
      {$limit: mongo.pageSize + 1},
      {$group: { _id: null, items : 
        { $push : {thread : {_id : "$threads._id", text : "$threads.text", user : "$threads.user", created : "$threads.created"}, replies : "$threads.replies"} } 
      }}
    ]
  ).then( (res) ->
    if !res.length 
      mongo.boards.aggregateAsync(
        [
          {$match : { "threads._id" : mongo.ObjectId threadId}},
          {$unwind : "$threads"},
          {$group: { _id: null, items : 
            { $push : {thread : {_id : "$threads._id", text : "$threads.text", user : "$threads.user", created : "$threads.created"} } } 
          }}
        ])
    else
      res
  ).then (res) ->  
    res = res[0]
    if res
      ret =
        hasMore : res.items.length == mongo.pageSize + 1
        thread : res.items[0].thread
        replies : res.items.map (m) -> m.replies      
      ret.thread.created = moment.utc(ret.thread.created).unix()
      ret.replies = ret.replies.filter (f) -> f
      ret.replies.forEach (m) -> m.created = moment.utc(m.created).unix()
      ret

exports.removeThread = (userKey, threadId) ->
  mongo.boards.updateAsync(
    {"threads._id" : mongo.ObjectId(threadId), "threads.user.key" : userKey},
    {$pull : { threads : {_id : mongo.ObjectId(threadId)} }},
    {save : true}
  ).then (res) ->
    if res.n == 0
      throw new Error "Thread #{threadId} not found"
    else
      res

exports.updateThread = (userKey, threadId, msg) ->
  mongo.boards.updateAsync(
    {"threads._id" : mongo.ObjectId(threadId), "threads.user.key" : userKey},
    {$set : { "threads.$.text" : msg }},
    {save : true}
  ).then (res) ->    
    if res.n == 0
      throw new Error "Thread #{threadId} not found"
    else
      res

exports.createReply = (user, threadId, msg) ->
  reply = 
    _id: mongo.ObjectId()
    created: new Date()
    user : user
    text : msg
  mongo.boards.updateAsync(
    {threads: { $elemMatch : { _id : mongo.ObjectId(threadId) } }},
    {$push : { "threads.$.replies" : {$each : [reply] , $position : 0} }},
    {save : true}
  ).then (res) ->
    if res.n == 0
      throw new Error "Thread #{threadId} not found"
    else
      reply.created = moment.utc(reply.created).unix()
      reply

exports.updateReply = (userKey, replyId, msg) ->
  mongo.boards.updateAsync(
    {"threads.replies" : {$elemMatch : {_id : mongo.ObjectId(replyId), "user.key" : userKey}}},
    {$set : { "replies.$.text" : msg }},
    {save : true}
  ).then (res) ->
    if res.n == 0
      throw new Error "Reply #{replyId} not found"
    else
      res

exports.removeReply = (userKey, replyId) ->
  mongo.boards.updateAsync(
    {"threads" : {$elemMatch : {"replies._id" : mongo.ObjectId(replyId), "replies.user.key" : userKey}}},
    {$pull : { "threads.$.replies" : { _id : mongo.ObjectId(replyId) } } },
    {save : true}
  ).then (res) ->
    if res.n == 0
      throw new Error "Reply #{replyId} not found"
    else
      res

