elasticsearch = require "elasticsearch"
config = require("../../config")
module.exports = new elasticsearch.Client host : config("ELASTIC_URI")
