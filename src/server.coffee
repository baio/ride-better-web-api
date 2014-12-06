require "newrelic"
hapi = require "hapi"
routes = require "./routes"
auth = require "./server-auth"
config = require "./config"
Promise = require "bluebird"

###
NODE_ENV
MONGO_URI
ELASTIC_URI
FORECASTIO_KEY
REDUCED_MONGO_URI
WEBCAMS_MONGO_URI
###

port = Number config("PORT")
serverOpts = config("server").opts
server = hapi.createServer port, serverOpts
server.route routes
auth(server, config("user"))

if !config("export_server")
  server.start ->
    console.log "Server [#{config("NODE_ENV")}] started on port #{port}"
else
  module.exports = server

