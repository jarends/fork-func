module.exports = (delay, msg, done) ->

    setTimeout () ->
        done null, delay + 'ms later ... ' + msg
    , delay

