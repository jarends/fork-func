Fork = require '../fork-func'


async = (arg) ->
    arg + '!!!'


class Cmd

    constructor: (arg) ->
        return async arg if @ == global


    execute: (arg) ->
        Fork __filename, arg, (error, result) =>
            if error
                console.log 'test error: ', error
            else
                console.log 'test result: ', result
        null


module.exports = Cmd