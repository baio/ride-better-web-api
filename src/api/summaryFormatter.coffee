formatSnowCover = (condition) ->
    switch condition
      when 0 then "very little snow"
      when 1 then "not enough snow"
      when 2 then "enough snow"
      when 3 then "much snow"
      when 4 then "lots of snow"
      else "unknown amount of snow"


formatSnowfall = (condition) ->
    switch condition
      when 0 then "snow does not fall out"
      when 1 then "not much snow fell"
      when 2 then "dropped enough snow"
      when 3 then "much snow fell"
      when 4 then "lots of snow fell"
      else "unknown amount of snow fell"

formatCrowd = (condition) ->
    switch condition
      when 0 then "very few people"
      when 1 then "few people"
      when 2 then "enough people"
      when 3 then "many people"
      when 4 then "too many people"
      else "unknown amount of people"

formatVariance = (condition) ->
  switch condition
    when 0 then "recent reports have strong opinions that"
    when 1 then "recent reports have opinions that"
    when 2 then "recent reports have divergent opinions, but majority report that"

module.exports.summary = (conditions, variance) ->
  if !conditions.tracks and !conditions.crowd and !conditions.snowing
    null
  else if variance?
    "#{formatVariance(variance)}  #{formatSnowCover(conditions.tracks)} and #{formatCrowd(conditions.crowd)} on the tracks, #{formatSnowfall(conditions.snowing)}"
  else
    "#{formatSnowCover(conditions.tracks)} and #{formatCrowd(conditions.crowd)} on the tracks, #{formatSnowfall(conditions.snowing)}"

module.exports.operate = (status) ->
  switch status
    when "open" then "open"
    when "closed" then "closed"
    when "off-season" then "off season"
    when "day-off" then "day off"