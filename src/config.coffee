nconf = require "nconf"
env = require "node-env-file"
env('./.env')

nconf
.argv()
.env()
.file(file: './config.json')
	
module.exports = (name) -> nconf.get(name)