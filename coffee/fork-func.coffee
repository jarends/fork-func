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
        call opts.path, opts.name, args, callback, false


    async = (path, args..., callback) ->
        opts = parse path
        call opts.path, opts.name, args, callback, true


    pimp = (obj, nameOrPath, path, async = false) ->
        if path
            key = nameOrPath
        else
            path = nameOrPath

        opts = parse path
        key  = translate key or opts.name or Path.basename(opts.path)

        obj[key] = (args..., callback) ->
            call opts.path, opts.name, args, callback, async
        obj




    call = (path, name, args, callback, async) ->
        try
            cp = CP.fork __filename, stdio: 'inherit'

            onMessage = (msg) ->
                callback msg.error, msg.result
                null

            onExit = () ->
                cp.removeListener 'message', onMessage
                cp.removeListener 'exit'   , onExit
                null

            cp.on 'message', onMessage
            cp.on 'exit'   , onExit

            cp.send
                path:  path
                name:  name
                args:  args
                async: async

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


    ForkFunc.async   = async
    ForkFunc.pimp    = pimp
    ForkFunc.default = ForkFunc # stupid hack to get ts default exports working


    module.exports = ForkFunc


else


    #     0000000  000   000  000  000      0000000  
    #    000       000   000  000  000      000   000
    #    000       000000000  000  000      000   000
    #    000       000   000  000  000      000   000
    #     0000000  000   000  000  0000000  0000000  
    
    call = (msg) ->
        try
            func = require msg.path
            func = func[msg.name] if msg.name
            # TODO: better error checking
            msg.args.push(ready) if msg.async
            result = func.apply null, msg.args
            ready(null, result) if not msg.async
        catch error
            ready error


    ready = (error, result) ->
        process.removeListener 'message', call
        process.send
            error:  error
            result: result


    process.on 'message', call




