"use strict"

gulp = require "gulp"
nodemon = require "gulp-nodemon"

gulp.task "nodemon", ->
  nodemon(script : "src/server.coffee")

gulp.task "default", ["dev-server"]
gulp.task "dev-server", ["nodemon"]




