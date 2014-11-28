

data =
  eu : ["km", "cm", "c"]
  uk : ["mi", "in", "c"]
  us : ["mi", "in", "f"]


exports.height = (culture, cm) ->
  if data[culture][1] != "cm"
    Math.round cm / 0.393701
  else
    cm

exports.heightU = (culture) ->
  data[culture][1]

exports.temp = (culture, c) ->
  if data[culture][2] != "c"
    Math.round c * 1.8 + 32
  else
    c

exports.tempU = (culture) ->
  if data[culture][2] == "c"
    "C"
  else
    "F"

exports.dist = (culture, km) ->
  if data[culture][0] != "km"
    Math.round km * 0.621371
  else
    km

exports.distU = (culture) ->
  data[culture][0]