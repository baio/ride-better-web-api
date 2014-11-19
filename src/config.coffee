nconf = require "nconf"
env = require "node-env-file"
env('../.env')

nconf
.argv()
.env()

try
	nconf.file(file: "../config.json")
catch e
	console.log ".env file not found, suppose all env properly set in enviroment"

if nconf.get("NODE_ENV")
	try
		nconf.file("transform", file: "../configs/#{nconf.get("NODE_ENV")}.config.json")
	catch e
		console.log "Transform configuration for [#{nconf.get("NODE_ENV")}] not found, use default"

module.exports = (name) -> nconf.get(name)