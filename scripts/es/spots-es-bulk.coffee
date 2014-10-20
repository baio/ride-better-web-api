fs = require "fs"
lazy = require "lazy"

#mongoexport --out "./spots.json" --db ride-better-dev --collection spots
#curl -s -XPOST localhost:9200/_bulk --data-binary @bulk.txt; echo
#curl -s -XPOST https://eszkh0q3:7w0zo4acg2sz893k@box-777024.us-east-1.bonsai.io:443/_bulk --data-binary @bulk.txt; echo

try
  fs.unlinkSync('./bulk.txt')
catch
  console.log ">>>spots-es-bulk.coffee:11"
new lazy(fs.createReadStream('./spots.json')).lines.forEach (line) ->
  j = JSON.parse line

  if j.latitude
    str = """
    { "index" : { "_index" : "rspots", "_type" : "spot", "_id" : \"#{j.id}\" } }
    { "label" : "#{j.name}", "geo" : {"lat" : #{j.latitude}, "lon" : #{j.longitude}} }
    """
  else
    str = """
    { "index" : { "_index" : "rspots", "_type" : "spot", "_id" : \"#{j.id}\" } }
    { "label" : "#{j.name}" }
    """

  fs.appendFileSync("./bulk.txt", str + "\n");


