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


    pimp = (obj, nameOrPath, pathOrAsync, async = false) ->
        if pathOrAsync and pathOrAsync == pathOrAsync + ''
            key  = nameOrPath
            path = pathOrAsync
        else
            path  = nameOrPath
            async = pathOrAsync

        opts = parse path
        key  = translate key or opts.name or Path.basename opts.path

        obj[key] = (args..., callback) ->
            call opts.path, opts.name, args, callback, async
        obj




    call = (path, name, args, callback, async) ->
        try

            onMessage = (msg) ->
                if msg.error
                    msg.error = JSON.parse msg.error
                    null
                callback msg.error, msg.result
                null

            onError = (error) ->
                callback error
                null

            onStdError = (data) ->
                data = data.toString().split /\r\n|\n/
                data.splice 0, 4
                parsed = /(.*?):\s(.*)/.exec data[0]
                callback
                    name:    parsed[1]
                    message: parsed[2]
                    stack:   data.join '\n'
                null

            onExit = () ->
                cp.removeListener 'message'     , onMessage
                cp.removeListener 'error'       , onError
                cp.removeListener 'exit'        , onExit
                cp.stderr.removeListener 'data' , onStdError
                null

            cp = CP.fork __filename, stdio: ['inherit', 'inherit', 'pipe', 'ipc']
            cp.on 'message', onMessage
            cp.on 'error'  , onError
            cp.on 'exit'   , onExit

            cp.stderr.on 'data', onStdError

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
            msg.args.push ready if msg.async
            result = func.apply null, msg.args
            ready null, result if not msg.async
        catch error
            ready JSON.stringify
                name:    error.name
                message: error.message
                stack:   error.stack
        null


    ready = (error, result) ->
        process.removeListener 'message', call
        process.send
            error:  error
            result: result


    process.on 'message', call




