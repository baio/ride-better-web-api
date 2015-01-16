bluebird = require "bluebird"
fhist = require "../data-access/reduced/fhist"
formatter = require "./summaryFormatter"
_ = require "underscore"

exports.getSummary = (opts) ->
  _.defaults opts, lang : "en", culture : "eu"  
  fhist.getSnowHistory([opts.spot])
  .then (res) ->
    if res.length
      summary : formatter.formatSnowHistory(opts.lang, opts.culture, res[0].items)

exports.getHist = (spots) ->
  fhist.getSnowHistory(spots)

