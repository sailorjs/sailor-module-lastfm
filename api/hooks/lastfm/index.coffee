###
Dependencies
###
translate = require 'sailor-translate'

###
Exports
###
module.exports = (sails) ->

  initialize: (cb) ->
    # TODO: Necessary?
    # translate.add sails.config.translations
    cb()
