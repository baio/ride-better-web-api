"use strict"

module.exports = [
  require("./spots-get")
  require("./home-get")
  require("./reports-post")
  require("./nearest-spot-get")
  require("./messages-post")
  require("./messages-get")
  require("./messages-delete")
  require("./webcams/webcams-latest-get")
  require("./webcams/webcams-next-get")
  require("./webcams/webcams-prev-get")
  require("./resorts/resorts-info-get")
  require("./resorts/resorts-maps-get")
  require("./resorts/resorts-prices-get")
  require("./resorts/resorts-info-main-put")
  require("./resorts/resorts-info-header-put")
  require("./resorts/resorts-contacts-put")
]