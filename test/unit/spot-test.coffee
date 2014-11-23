expect = require("chai").expect



describe "test spots api", ->

  it "get spots for geo 55.76220610000001,37.678805", (next) ->
    spotsGet(null, [55.76220610000001,37.678805]).then (res) ->
      console.log ">>>reports-test.coffee:9", res
      next()

  it "get nearest spot for geo 55.76220610000001,37.678805", (next) ->
    @server.inject url : "/nearest-spot?geo=55.76220610000001,37.678805", method: "get", (resp) ->
      console.log ">>>reports-test.coffee:9", resp.result
      next()

  it.only "get spots for empty request", (next) ->
    @server.inject url : "/spots?geo=55.76220610000001,37.678805&term=", method: "get", (resp) ->
      console.log ">>>reports-test.coffee:19", resp.result
