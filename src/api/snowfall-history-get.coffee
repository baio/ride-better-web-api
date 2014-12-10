bluebird = require "bluebird"
fhist = require "../data-access/reduced/fhist"
formatter = require "./summaryFormatter"
_ = require "underscore"

module.exports = (opts) ->
  _.defaults opts, lang : "en", culture : "eu"
  fhist.getSnowHistory(opts.spot)
  .then (res) ->
	  	summary : formatter.formatSnowHistory(opts.lang, opts.culture, res)
	  	items : res	

