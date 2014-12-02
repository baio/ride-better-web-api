expect = require("chai").expect

orgs = require "../../src/data-access/ads/orgs"
ads = require "../../src/data-access/ads/ads"

describe "test ads api", ->

  @user =
    key : "unk_baio"

  it "create org", (next) ->
    org =
      name : "data-avail"
      contacts : [{type : "email", val : "max.putilov@gmail.com"}]
    orgs.createOrg(@user, org)
    .then (res) => @_orgId = res._id
    .finally next

  it "update org", (next) ->
    org =
      name : "data-avail !"
      contacts : [{type : "email", val : "max.putilov@gmail.com"}]
    orgs.updateOrg(@user, org)
    .then (res) => @_orgId = res._id
      .finally next

  describe.only "CRUD ad", ->

    it "create ad", (next) ->
      ad =
        type : "service"
        title : "IT services"
        text : "Blah blah blah blah"
        fotos : []
      ads.createAd(@user, ad)
      .then (res) =>
        @_adId = res._id
      .finally next

    it "edit ad", (next) ->
      ad =
        _id :  @_adId
        type : "service"
        title : "IT services"
        text : "*** Blah blah blah blah"
        fotos : []
      ads.updateAd(@user, ad).finally next

    it.skip "remove ad", (next) ->
      ads.removeAd(@user, @_adId).finally next

  it "remove org", (next) ->
    ads.removeOrg(@user, @_orgId).finally next
