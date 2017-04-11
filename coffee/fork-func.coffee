if module.parent

    #    00     00   0000000   000  000   000
    #    000   000  000   000  000  0000  000
    #    000000000  000000000  000  000 0 000
    #    000 0 000  000   000  000  000  0000
    #    000   000  000   000  000  000   000

    CP   = require 'child_process'
    Path = require 'path'


    ForkFunc = (path, args..., callback) ->
        opts = parse path
        call opts.path, opts.name, args, callback


    pimp = (obj, nameOrPath, path) ->
        if path
            key = nameOrPath
        else
            path = nameOrPath

        opts = parse path
        path = opts.path
        name = opts.name
        key  = translate key or name or Path.basename(path)

        obj[key] = (args..., callback) ->
            call path, name, args, callback
        obj




    call = (path, name, args, callback) ->
        try
            cp = CP.fork __filename, stdio: 'inherit'

            onMessage = (msg) ->
                result = msg.result
                error  = msg.error
                callback error, result
                null

            onExit = () ->
                cp.removeListener 'message', onMessage
                cp.removeListener 'exit'   , onExit
                null

            cp.on 'message', onMessage
            cp.on 'exit'   , onExit

            cp.send
                path: path
                name: name
                args: args

        catch error
            callback error, null
        cp


    parse = (path) ->
        if /^[.]?\.\//.test path
            stack = new Error().stack.split /\r\n|\n/
            path  = Path.join Path.dirname(/\((.*?):/.exec(stack[3])[1]), path

        name = null
        args = /(.*)::(.*)/.exec path
        if args and args.length
            path = args[1]
            name = args[2]

        path: path
        name: name


    translate = (key) ->
        key = key.replace /(-(.))/g, (args...) ->
            args[2].toUpperCase()
        key


    ForkFunc.pimp = pimp


    module.exports = ForkFunc


else


    #     0000000  000   000  000  000      0000000  
    #    000       000   000  000  000      000   000
    #    000       000000000  000  000      000   000
    #    000       000   000  000  000      000   000
    #     0000000  000   000  000  0000000  0000000  
    
    call = (msg) ->
        try
            path   = msg.path
            name   = msg.name
            args   = msg.args
            func   = require path
            func   = func[name] if name
            # TODO: better error checking
            result = func.apply null, args
            process.removeListener 'message', call
            process.send
                result: result
        catch error
            process.removeListener 'message', call
            process.send
                error: error


    process.on 'message', call




