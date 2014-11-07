"use strict"

async = require "async"
models = require "../../src/models"
skimapData = "./skimap"

module.exports = (done) ->

  async.parallel [
    (ck) -> models.spot.remove {}, (err) -> ck(err)
    (ck) -> models.report.remove {}, (err) -> ck(err)
    (ck) -> models.skimap.remove {}, (err) -> ck(err)
  ], ->
    skimap = new models.skimap id : "1936", "latitude" : 54.773888,  "longitude" : 58.526112
    skimap.save(done)

