module.exports = (delay, msg) ->

    start = Date.now()
    while Date.now() - start < delay
        null

    return delay + 'ms later ... ' + msg
