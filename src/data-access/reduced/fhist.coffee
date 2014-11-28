mongo = require "./mongo"
moment = require "moment"
_ = require "underscore"


exports.getSnowHistory = (spot) ->
  mongo.fhist.findOneAsync(_id : spot)
  .then (res) ->
      if res
        amts = res.value.amounts.filter (f) -> f.type == "snow"
        amts = _.sortBy amts, (amt) -> amt.date
        iter = moment.utc().startOf("d").add(-2, "d").unix()
        res = []
        #find sequency of days with defined snow precipitation amount
        #if rain fallen all reset!
        for amt in amts
          if amt.date == iter
            res.push amt
            iter = moment.utc(iter, "X").add(-1, "d").unix()
          else
            break
        if res.length
          days : res.length
          amount : _.reduce(res, ((s1, s2) -> s1 + s2.amount), 0)
          items : res







