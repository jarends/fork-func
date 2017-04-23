module.exports = (delay, msg) ->

    start = Date.now()
    while Date.now() - start < delay
        null

    #throw new Error('Custom Error sync')

    return delay + 'ms later ... ' + msg
