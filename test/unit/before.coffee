"use strict"

server = require "../../src/server"

before (next) ->
  @server = server
  setTimeout next, 200