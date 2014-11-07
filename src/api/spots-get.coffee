"use strict"

elasticsearch = require "elasticsearch"

config = require("yaml-config").readConfig('./configs.yml', process.env.NODE_ENV).elasticsearch
config ?= host : process.env.BONSAI_URL
client = new elasticsearch.Client config
Q = require "q"

module.exports = (geo, term) ->

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
  else if match
    q = query : match

  if q
    s =
      index: "rspots"
      type: "spot"
      body : q
    client.search(s).then (res) ->
      res.hits.hits.map (m) ->
        r = m._source
        r.id = m._id
        if m.sort
          r.dist = Math.round m.sort[1]
        r.label = null if !r.label
        r
  else
    Q([])

