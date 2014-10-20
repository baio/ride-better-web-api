module.exports =
  method : "GET"
  path : "/login"
  handler : (req, resp) ->
    user = req.auth.credentials
    resp user
