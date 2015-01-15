Promise = require "bluebird"
elastic = require "./elastic"

exports.index = (spot, data) ->
  q = 
    index : "rspots"
    type : "spot"
    id : spot
    body :
      label : data.title

  if data.geo
    q.body.geo =
      lat : data.geo[0]
      lon : data.geo[1]
  
  elastic.index(q)

exports.findSpots = (term, geo) ->
  console.log ">>>spot.coffee:9", term, geo
  if term
    match = match : "label.autocomplete" : {"query" : term, "fuzziness": "AUTO"}
  if geo
    q =
      sort : [
        "_score",
        {
          _geo_distance :
            geo :
              lat : geo[0]
              lon : geo[1]
            order : "asc",
            unit : "km"
        }]

    if match
      q.query =
        function_score :
          functions : [
            script_score :
              script : if geo then "doc['geo'].value != null && doc['geo'].distanceInKm(#{geo[0]}, #{geo[1]}) < 50 ? _score * 1000 : _score" else "_score"
          ]
          query : match
  else
    q = query : match

  if match
    q.highlight =  fields : {"label.autocomplete" : {} }

  if q
    s =
      index: "rspots"
      type: "spot"
      body : q
    elastic.search(s).then (res) ->
      res.hits.hits.map (m) ->
        r = m._source
        r.code = m._id
        if r.geo
          r.dist = Math.round m.sort[1]
        if m.highlight
          r.label = m.highlight["label.autocomplete"][0]
        r
  else
    Promise.resolve []


exports.nearestSpots = (geo) ->
  q =
    sort : [
      "_score",
      {
        _geo_distance :
          geo :
            lat : geo[0]
            lon : geo[1]
          order : "asc",
          unit : "km"
      }],
    size : 5
  s =
    index: "rspots"
    type: "spot"
    body : q
  elastic.search(s).then (res) ->
    res.hits.hits.map (m) ->
      r = m._source
      r.code = m._id
      r.dist = Math.round m.sort[1]
      r
