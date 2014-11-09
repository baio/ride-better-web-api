langs =
  ru : require "./ru"

module.exports = (txt, lang) ->
  if lang
    langs[lang][txt]
  else
    txt