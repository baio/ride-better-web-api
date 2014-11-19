#require "newrelic"
hapi = require "hapi"
mongoose = require "mongoose"
routes = require "./routes"
auth = require "./server-auth"
config = require "./config"
Promise = require "bluebird"

Promise.promisifyAll mongoose

mongoose.connect config("MONGO_URI")

port = Number config("PORT")
serverOpts = config("server").opts
server = hapi.createServer port, serverOpts
server.route routes
auth(server, config("user"))

console.log ">>>server.coffee:16", config("export_server")

if !config("export_server")
  server.start ->
    console.log "Server [#{config("NODE_ENV")}] started on port #{port}"
else
  module.exports = server

