"use strict"

server = require "../../src/server"
config = require "../../src/config"

before (next) ->
  @server = server
  @user = config "user"
  next()