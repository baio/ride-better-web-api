langs =
  ru : require "./ru"

module.exports = (txt, lang) ->
  if lang and lang != "en"
    langs[lang][txt]
  else
    txt