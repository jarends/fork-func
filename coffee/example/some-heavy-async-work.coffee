module.exports = (delay, msg, done) ->

    setTimeout () ->
        #throw new Error('Custom Error async')
        done null, delay + 'ms later ... ' + msg
    , delay

