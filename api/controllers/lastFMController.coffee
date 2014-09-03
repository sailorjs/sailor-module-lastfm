## -- Dependencies -----------------------------------------------------------------------

translate   = require 'sailor-translate'
errorify    = require 'sailor-errorify'

## -- Exports -----------------------------------------------------------------------

module.exports =

  endpoint: (req, res)->
    req.checkParams('method', translate.get "LastFM.Method.NotFound").notEmpty()
    req.checkParams('action', translate.get "LastFM.Action.NotFound").notEmpty()
    return res.badRequest(errorify.serialize(req)) if req.validationErrors()

    params = do req.params.all

    method = params.method
    action = params.action

    delete params.action
    delete params.method


    res.ok(params)

    # LastFMService.do method, action, params, (err, response) ->
    #   return res.badRequest(err) if err
    #   res.ok(response)

    # res.ok("#{method} and #{action}")
