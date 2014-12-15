mongo = require("./mongo")
webcams = mongo.webcams
resorts = mongo.resorts
Promise = require "bluebird"
moment = require "moment"




getOne = (q, s, nostream) ->
  console.log "index.coffee:11 >>>", q, s, nostream
  resorts.findOneAsync({_id : q.spot}, webcams : 1)
  .then (res) ->
    if res
      if nostream
        res.webcams = res.webcams.filter((f) -> f.meta?.type != "stream")
      if q.index
        current = res.webcams.filter((f) -> f.index == q.index)[0]
      else
        current = res.webcams[0]
      if current.meta?.type == "stream"
        current : current
        list : res.webcams
      else
        s ?= created : -1
        q.index = current.index
        cursor = webcams.find(q).sort(s).limit(1)
        Promise.promisify(cursor.toArray, cursor)().then (res1) ->
          res1 = res1[0]
          if res1
            current.meta =
              created : moment.utc(res1.created).unix()
              src : "https://dataavail.blob.core.windows.net/ride-better-webcams/" + res1.key
              type : "img"
          current : current
          list : res.webcams

exports.getLatest = (spot, index, nostream) ->
  getOne {spot : spot, index : index}, created : -1, nostream

exports.getNext = (spot, index, date, nostream) ->
  getOne {spot : spot, index : index, created : $gt : moment.utc(date + 1, "X").toDate()}, created : 1, nostream

exports.getPrev = (spot, index, date, nostream) ->
  getOne {spot : spot, index : index,  created : $lt : moment.utc(date, "X").toDate()}, created : -1, nostream