"use strict"

gulp = require "gulp"
rename = require "gulp-rename"
nodemon = require "gulp-nodemon"

argvs = process.argv.slice(2)
if argvs[1]
  $ENV = argvs[1][2..]


gulp.task "nodemon", ->
  nodemon(script : "src/server.coffee")

gulp.task "cpy-config", ->
  gulp.src("./configs/#{$ENV}.config.json").pipe(rename("config.json")).pipe(gulp.dest ".")

gulp.task "env", ["cpy-config"],->
  argvs = process.argv.slice(2)
  if argvs[1]
    env = argvs[1][2..]
    gulp.src("./.envs/#{$ENV}.env").pipe(rename(".env")).pipe(gulp.dest ".")
  else
    console.log "Please pass argument such as --dev"

gulp.task "default", ["run"]
gulp.task "run", ["nodemon"]





