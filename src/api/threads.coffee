threadsDA = require "../data-access/board/threads"
spotsDA = require "../data-access/mongo/spots"
summaryFormatter = require "./summaryFormatter"

mapThread = (thread, opts) ->
  if thread.tags.indexOf("report") != -1
    if thread.data.meta?.conditions
      culture = opts.culture
      culture ?= "en-eu"
      spts = culture.split("-")      
      thread.data.meta.summary = summaryFormatter.summary(spts[0], thread.data.meta.conditions)
  thread

exports.createThread = (user, prms, msg) ->
  spotsDA.getSpot(prms.spot).then (spot) ->
    msg.spot = spot
    threadsDA.createThread(user, prms, msg)

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

exports.createTransferRequest = (user, threadId) ->
  threadsDA.createTransferRequest(user, threadId)

exports.removeTransferRequest = (user, threadId) ->
  threadsDA.removeTransferRequest(user, threadId)

exports.acceptTransferRequest = (user, threadId, requestUerKey, isAccept) ->
  threadsDA.acceptTransferRequest(user, threadId, requestUerKey, isAccept)
