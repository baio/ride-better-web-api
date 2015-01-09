threadsDA = require "../data-access/board/threads"

exports.createThread = (user, tags, msg) ->
  threadsDA.createThread(user, tags, msg)

exports.getThreads = (tags, opts) ->
  threadsDA.getThreads(tags, opts)

exports.updateThread = (user, threadId, data) ->
  threadsDA.updateThread(user, threadId, data)

exports.removeThread = (user, threadId) ->
  threadsDA.removeThread(user, threadId)

exports.getThread = (threadId, opts) ->
  threadsDA.getThread(threadId, opts)

exports.createReply = (user, threadId, msg) ->
  threadsDA.createReply(user, threadId, msg)

exports.updateReply = (user, replyId, msg) ->
  threadsDA.updateReply(user, replyId, msg)

exports.removeReply = (user, replyId) ->
  threadsDA.removeReply(user, replyId)

