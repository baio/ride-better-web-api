"use strict"

prepareDbForTests = require "../test-data/prepareDbForTests"

before (next) ->
  prepareDbForTests(next)