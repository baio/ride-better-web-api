nconf = require "nconf"
env = require "node-env-file"
env('./.env')

nconf
.argv()
.env()
.file(file: "./config.json")

if nconf.get("NODE_ENV")
	try
		nconf.file("transform", file: "./configs/#{nconf.get("NODE_ENV")}.config.json")
	catch e
		console.log "Transform configuration for [#{nconf.get("NODE_ENV")}] not found, use default"

module.exports = (name) -> nconf.get(name)