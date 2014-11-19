nconf = require "nconf"
env = require "node-env-file"
env('./.env')

nconf
.argv()
.env()
.file(file: "./config.json")

if nconf.get("NODE_ENV")
	try
		nconf(file: "./configs/#{nconf.get("NODE_ENV")}.config.json")
	catch
	
module.exports = (name) -> nconf.get(name)