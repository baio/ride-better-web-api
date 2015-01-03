mongo = require "./mongo"
thread = require "./thread"
moment = require "moment"

exports.createBoard = (board) ->
  board.threads = []
  board._id = mongo.getBoardId(board.tags)
  board.created = new Date()
  mongo.boards.insertAsync(board).then (res) -> res[0]

exports.removeBoard = (tags) ->
  mongo.boards.removeAsync(_id : mongo.getBoardId(tags)).then (res) -> res[0]

exports.getBoard = (tags, opts) ->
  since = moment.utc(opts.since, "X").toDate() if opts?.since
  till = moment.utc(opts.till + 1, "X").toDate() if opts?.till
  query = {}
  query.$lt = since if since
  query.$gt = till if till
  if query.$lt or query.$gt
    query = "threads.created" : query

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

exports.upsertBoardAndThread = (user, board, data) ->
  boardId = mongo.getBoardId(board.tags)
  threadDoc =  thread.mapThread(user, data)
  mongo.boards.updateAsync(
    { _id : boardId },
    {
      $setOnInsert: board
      $push : threads :  {$each : [threadDoc], $position : 0}
    },
    upsert : true
  ).then (res) ->
    threadDoc.created = moment(threadDoc.created).utc().unix()
    threadDoc

