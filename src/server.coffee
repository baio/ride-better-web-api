require "newrelic"
hapi = require "hapi"
mongoose = require "mongoose"
routes = require "./routes"
auth = require "./server-auth"
config = require "./config"

mongoose.connect config("MONGO_URI")

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

