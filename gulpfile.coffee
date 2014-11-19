"use strict"

gulp = require "gulp"
rename = require "gulp-rename"
nodemon = require "gulp-nodemon"


gulp.task "nodemon", ->
  nodemon(script : "src/server.coffee")

gulp.task "env", ->
  argvs = process.argv.slice(2)
  if argvs[1]
    env = argvs[1][2..]
    gulp.src("./.envs/#{env}.env").pipe(rename(".env")).pipe(gulp.dest ".")
  else
    console.log "Please pass argument such as --dev"

gulp.task "default", ["run"]
gulp.task "run", ["nodemon"]





