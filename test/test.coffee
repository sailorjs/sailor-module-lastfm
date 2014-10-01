## -- Dependencies -----------------------------------------------------------------------

url       = require './helpers/urlHelper'
should    = require 'should'
request   = require 'superagent'

## -- Test ------------------------------------------------------------------------------

describe "LastFM :: API", ->

  describe '200 OK', ->

    describe 'Artist', ->

      it 'get info about a band', (done) ->
        request
        .get url.lastfm + "/artist/getInfo"
        .query
          artist: 'Daft Punk'
        .end (res) ->
          res.status.should.equal 200
          res.body.name.should.eql 'Daft Punk'
          done()

      it 'get info about a band by lang', (done) ->
        request
        .get url.lastfm + "/artist/getInfo"
        .query
          artist: 'Daft Punk'
          lang  : 'es'
        .end (res) ->
          res.status.should.equal 200
          res.body.name.should.eql 'Daft Punk'
          res.body.bio.summary.should.match /dúo francés/
          done()

      it 'get similar artists to another artist', (done) ->
        request
        .get url.lastfm + "/artist/getSimilar"
        .query
          artist: 'Daft Punk'
          limit : "1"
        .end (res) ->
          res.status.should.equal 200
          res.body.artist.name.should.eql 'Justice'
          done()

    describe 'Event', ->

      xit 'Get all events in a specific location by city name', (done) ->
        request
        .get url.lastfm + "/event/getInfo"
        .query
          event: '328799'
        .end (res) ->
          console.log res
          res.status.should.equal 200
          res.body.id.should.eql 328799
          done()

    describe 'Geolocation', ->

      it 'Get all events in a specific location by coordinates', (done) ->
        request
        .get url.lastfm + "/geo/getEvents"
        .query
          lat: '37.9922399'
          long: '-1.1306544000000258'
        .end (res) ->
          res.status.should.equal 200
          done()


  describe '400 BadRequest', ->

    it 'bad formed query', (done) ->
      request
      .get url.lastfm
      .end (res) ->
        res.status.should.equal 400
        done()

    it 'API path bad formed', (done) ->
      request
      .get url.lastfm + "/artist/GETINFO"
      .end (res) ->
        res.status.should.equal 400
        done()
