res = require "../res"
moment = require "moment"

formatSnowCover = (condition, lang) ->
    switch condition
      when 0 then res "very little snow", lang
      when 1 then res "not enough snow", lang
      when 2 then res "enough snow", lang
      when 3 then res "much snow", lang
      when 4 then res "lots of snow", lang
      else res "unknown amount of snow", lang


formatSnowfall = (condition, lang) ->
    switch condition
      when 0 then res "snow does not fall out", lang
      when 1 then res "not much snow fell", lang
      when 2 then res "dropped enough snow", lang
      when 3 then res "much snow fell", lang
      when 4 then res "lots of snow fell", lang
      else res "unknown amount of snow fell", lang

formatCrowd = (condition, lang) ->
    switch condition
      when 0 then res "very few people", lang
      when 1 then res "few people", lang
      when 2 then res "enough people", lang
      when 3 then res "many people", lang
      when 4 then res "too many people", lang
      else res "unknown amount of people", lang

formatVariance = (condition, lang) ->
  switch condition
    when 0 then res "recent reports have strong opinions that", lang
    when 1 then res "recent reports have opinions that", lang
    when 2 then res "recent reports have divergent opinions, but majority report that", lang

module.exports.summary = (lang, conditions, variance) ->
  if !conditions.tracks and !conditions.crowd and !conditions.snowing
    null
  else if variance?
    "#{formatVariance(variance, lang)}  #{formatSnowCover(conditions.tracks, lang)} #{res "and", lang} #{formatCrowd(conditions.crowd, lang)} #{res "on the tracks", lang}, #{formatSnowfall(conditions.snowing, lang)}"
  else
    "#{formatSnowCover(conditions.tracks, lang)} #{res "and", lang} #{formatCrowd(conditions.crowd, lang)} #{res "on the tracks", lang}, #{formatSnowfall(conditions.snowing, lang)}"

operateStatus = (lang, status) ->
  switch status
    when "open" then res "open", lang
    when "closed" then res "closed", lang
    when "off-season" then res "off season", lang
    when "day-off" then res "day off", lang

module.exports.notOperate = (lang, operate) ->
  r = res("Latest report suggests that place is NOT operating", lang)
  if operate.status != "closed"
    r = r + ", " + res("because of", lang) + " " + operateStatus(lang, operate.status)
  r = r + "."
  if operate.openDate
    openDate = moment.utc(operate.openDate, "X")
    r = r + " " + res("Suggested open date is", lang) + " " +
      openDate.locale(lang).format("D MMMM") + "."
  r

module.exports.noReports = (lang) ->
  res "No reports for last two days", lang
