threadsDA = require "../data-access/board/threads"
summaryFormatter = require "./summaryFormatter"

mapThread = (thread, opts) ->
  if thread.tags.indexOf("report") != -1
    if thread.data.meta?.conditions
      thread.data.meta.summary = summaryFormatter.summary(opts.lang, thread.data.meta.conditions)
  thread

exports.createThread = (user, tags, msg) ->
  threadsDA.createThread(user, tags, msg)

exports.getThreads = (tags, opts) ->
  threadsDA.getThreads(tags, opts)
  .then (res) -> 
    res.map (m) -> mapThread(m, opts)

exports.updateThread = (user, threadId, data) ->
  threadsDA.updateThread(user, threadId, data)

exports.removeThread = (user, threadId) ->
  threadsDA.removeThread(user, threadId)

exports.getThread = (threadId, opts) ->
  threadsDA.getThread(threadId, opts)
  .then (res) -> mapThread res, opts

exports.createReply = (user, threadId, msg) ->
  threadsDA.createReply(user, threadId, msg)

exports.updateReply = (user, replyId, msg) ->
  threadsDA.updateReply(user, replyId, msg)

exports.removeReply = (user, replyId) ->
  threadsDA.removeReply(user, replyId)

