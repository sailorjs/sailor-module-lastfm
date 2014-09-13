## -- Dependencies -------------------------------------------------------------

LastFM_API   = require 'lastfmapi'
translate    = require 'sailor-translate'
errorify     = require 'sailor-errorify'
lastFMConfig = sails.config.lastfm

lastFM = new LastFM_API
  api_key: lastFMConfig.key
  secret : lastFMConfig.secret

NOT_OBJECT_ERROR =
  code: 6

firstProperty = (obj) ->
  obj[Object.keys(obj)[0]]


## -- Exports ------------------------------------------------------------------

module.exports =

  api: (method, action, query, cb) ->

    try
      lastFM[method][action] query, (err, data) ->
        cb(err, data) unless err
        cb(err, data) if err and err?.error? isnt NOT_OBJECT_ERROR.code

        # Case when the method need a single param instead of a Object.
        # try to fix the error
        index = firstProperty(query)
        lastFM[method][action] index, (err, data) ->
          cb(err, data)

    catch e
      cb(errorify.serialize translate.get "LastFM.BadFormat", null)
