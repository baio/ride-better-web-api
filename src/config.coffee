nconf = require "nconf"
env = require "node-env-file"
env(__dirname + '/../.env')

nconf
.argv()
.env()
.file(file: __dirname + "/../config.json")

if nconf.get("NODE_ENV")
	try
		nconf.file("transform", file: __dirname + "/../configs/#{nconf.get("NODE_ENV")}.config.json")
	catch e
		console.log "Transform configuration for [#{nconf.get("NODE_ENV")}] not found, use default"

module.exports = (name) -> nconf.get(name)