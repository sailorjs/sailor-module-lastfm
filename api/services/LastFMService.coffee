## -- Dependencies -------------------------------------------------------------

LastFM_API = require 'lastfmapi'

LastFM = new LastFM_API
  api_key: sails.config.lastfm.api_key
  secret : sails.config.lastfm.secret

firstProperty = (obj) ->
  obj[Object.keys(obj)[0]]

NOT_OBJECT_ERROR =
  code: 6


## -- Exports ------------------------------------------------------------------

module.exports =

  do: (method, action, query, cb) ->

    LastFM[method][action] query, (err, info) ->
      cb(err, info) unless err
      cb(err, info) if err and err.error isnt NOT_OBJECT_ERROR.code

      # try to fix the error
      index = firstProperty(query)
      LastFM[method][action] index, (err, info) ->
        cb(err, info)





