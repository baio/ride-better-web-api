"use strict"
Hapi = require "hapi"
jwt = require "jsonwebtoken"
jwt_secret = require("./config")("JWT_SECRET")
Promise = require "bluebird"


getJWT = (headers) ->
  deferred = Promise.defer()
  authHeader = headers["authorization"]
  if !authHeader
    deferred.reject new Error "authorization header not found"
  else
    spts = authHeader.split(' ')
    if spts.length != 2 or spts[0] != "Bearer"
      deferred.reject new Error "bearer not found"
    else
      bearer =  spts[1]
      jwt.verify bearer, jwt_secret, (err, decoded) ->
        if err
          deferred.reject err
        else
          deferred.resolve decoded
  deferred.promise

module.exports = (server, defaultUser) ->

  server.auth.scheme "auth", ->

    authenticate: (request, reply) ->
      if defaultUser
        reply null, credentials : defaultUser 
      else
        getJWT(request.headers).then (res) ->
          reply null,
            credentials :
              key : res.provider + "_" + res.id
              id : res.id
              name : res.name
              provider  : res.provider
              avatar : res.avatar
        ,(err) ->
          reply Hapi.error.unauthorized(err)

  server.auth.strategy "auth", "auth", true