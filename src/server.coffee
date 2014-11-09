require "newrelic"

hapi = require "hapi"
mongoose = require "mongoose"
routes = require "./routes"
auth = require "./server-auth"

if !process.env.NODE_ENV
  console.log "NODE_ENV not defined, exit."
  process.exit 1

config = require("yaml-config").readConfig('./configs.yml', process.env.NODE_ENV)

mongoose.connect(config.mongo?.uri || process.env.MONGOLAB_URI)

port = Number(process.env.PORT || config.server.port)
server = hapi.createServer port, config.server.opts
server.route routes
auth(server, config.auth?.user)

if process.env.NODE_ENV != "test"
  server.start ->
    console.log "Server [#{process.env.NODE_ENV}] started on port #{port}"
else
  module.exports = server

