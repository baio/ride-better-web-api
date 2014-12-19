mongo = require "./mongo"

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
    query = "threads.message.created" : query

  id = mongo.getBoardId(tags)

  mongo.boards.aggregateAsync(
    [
      {$match : { _id : id}},
      {$unwind : "$threads"},
      {$match : if query then query else {}},
      {$limit: mongo.pageSize + 1},
      {$group: { _id: "$_id", threads : { $push : "$threads" } }}
    ]
  ).then (res) ->
    board = res[0]
    if board
      board.hasMore = board.threads.length == mongo.pageSize + 1
      board.threads = board.threads[0..mongo.pageSize - 1]
      thrd.created = moment.utc(thrd.created).unix() for thrd in board.threads
    board


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
  ).then (res, res1) ->
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

