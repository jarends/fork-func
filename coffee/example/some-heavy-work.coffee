module.exports = (delay, msg) ->

    start = Date.now()
    while Date.now() - start < delay
        null

    #throw new Error('Custom Error sync')

    delay + 'ms later ... ' + msg
