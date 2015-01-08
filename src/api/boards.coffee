boardDA = require "../data-access/da-board/board"
threadDA = require "../data-access/da-board/thread"

exports.createThread = (user, spot, board, msg) ->
  bd = 
      spot : spot
      title : board
      tags : [spot, board]         
  boardDA.upsertBoardAndThread(user, bd, msg)

exports.updateThread = (user, threadId, data) ->
  threadDA.updateThread(user.key, threadId, data)

exports.createReply = (user, threadId, msg) ->
  threadDA.createReply(user, threadId, msg)

exports.upadteReply = (user, replyId, msg) ->
  threadDA.updateReply(user, replyId, msg)

exports.getBoard = (user, spot, opts) ->
  boardDA.getBoard([spot, user], opts)

exports.removeReply = (user, replyId) ->
  threadDA.removeReply(user.key, replyId)

exports.removeThread = (user, threadId) ->
  threadDA.removeThread(user.key, threadId)

exports.getThread = (threadId, opts) ->
  threadDA.getThread(threadId, opts)
