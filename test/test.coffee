## -- Dependencies -----------------------------------------------------------------------

pkg       = require '../package.json'
url       = require './helpers/urlHelper'
fs        = require 'fs'
should    = require 'should'
request   = require 'superagent'
scripts   = require 'sailor-scripts'
LastfmAPI = require 'lastfmapi'

## -- Setup ------------------------------------------------------------------------------

opts =
  log: level: "silent"
  plugins: [pkg.name]

MODULE = process.cwd()
LINK   = "#{process.cwd()}/testApp/node_modules/sailor-module-user"

# before (done) ->
#   if (!fs.existsSync("#{MODULE}/testApp"))
#     scripts.newBase ->
#       scripts.link MODULE, LINK, ->
#         scripts.writePluginFile pkg.name, ->
#           scripts.lift opts, done
#   else
#     scripts.clean "#{MODULE}/.tmp/"
#     scripts.clean "#{MODULE}/testApp/.tmp/"
#     scripts.lift opts, done

LastFM = new LastfmAPI
  api_key: process.env.LASTFM_API_KEY
  secret: process.env.LASTFM_SECRET


NOT_OBJECT_ERROR =
  code: 6

firstProperty = (obj) ->
  obj[Object.keys(obj)[0]]

_do = (method, action, query, cb) ->
  LastFM[method][action] query, (err, info) ->
    cb(err, info) unless err
    cb(err, info) if err and err.error isnt NOT_OBJECT_ERROR.code

    # try to fix the error
    index = firstProperty(query)
    LastFM[method][action] index, (err, info) ->
      cb(err, info)

## -- Test ------------------------------------------------------------------------------

describe "LastFM API ::", ->

  describe 'Artist', ->

    it 'get info about a band', (done) ->

      query =
        artist: "Daft Punk"

      _do 'artist', 'getInfo', query, (err, info) ->
        throw err  if err
        info.name.should.eql 'Daft Punk'
        done()

    it 'get info about a band by lang', (done) ->

      query =
        artist: "Daft Punk"
        lang: 'es'

      _do 'artist', 'getInfo', query, (err, info) ->
        throw err  if err
        info.bio.summary.should.match /dúo francés/
        done()

    it 'get similar artists to another artist', (done) ->

      query =
        artist: "Daft Punk"
        limit : "1"

      _do 'artist', 'getSimilar', query, (err, info) ->
        throw err  if err
        info.artist.name.should.eql 'Thomas Bangalter'
        done()

  describe 'Event', ->

    it 'Get all events in a specific location by city name', (done) ->

      query =
        event: '328799'

      _do 'event', 'getInfo', query, (err, info) ->
        info.id.should.eql 328799
        done()

  describe 'Geo', ->

    query =
      lat: '37.9922399'
      long: '-1.1306544000000258'

    it 'Get all events in a specific location by coordinates', (done) ->
      _do 'geo', 'getEvents', query, (err, info) ->
        throw err  if err
        done()

describe "LastFM Module ::", ->


