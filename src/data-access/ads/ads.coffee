mongo = require "./mongo"

exports.createAd = (spot, ad) ->
  date = moment().utc()
  orgDoc =
  adDoc =
    spot : spot
    title : null
    tags : ["daily", "talk"]
    _user : message._user
  board.upsertBoardAndThread(boardDoc, message).then (res) ->
    res.message.created = moment.utc(res.message.created).unix()
    res
