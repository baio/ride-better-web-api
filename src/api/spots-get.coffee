"use strict"

elasticsearch = require "elasticsearch"

config = require("yaml-config").readConfig('./configs.yml', process.env.NODE_ENV).elasticsearch
config ?= host : process.env.BONSAI_URL
client = new elasticsearch.Client config
Q = require "q"

module.exports = (geo, term) ->
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
        }
    ]

  if term
      match : "label.autocomplete" :   {"query" : term, "fuzziness": "AUTO"}
  else
    q ?= {}
    q.query =
      function_score :
        functions : [
          script_score :
           script : if geo then "doc['geo'].distanceInKm(#{geo[0]}, #{geo[1]}) < 50 ? _score * 1000 : _score" else "_score"
        ]
        query :
          bool : should : matches
    q.highlight =  fields : {"label.autocomplete" : {}}

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
        if m.highlight
          r.label = m.highlight["label.autocomplete"][0]
        r
  else
    Q([])

