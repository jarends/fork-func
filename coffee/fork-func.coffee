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


    async = (path, args..., callback) ->
        opts = parse path
        call opts.path, opts.name, args, callback, true


    sync = (path, args...) ->
        opts      = parse path
        opts.args = args

        if typeof path == 'function'
            opts.code = opts.path.toString()
            opts.path = null

        args = [__filename, JSON.stringify opts]

        try
            result = CP.spawnSync 'node', args, stdio: ['pipe', 'pipe', 'pipe']
            result = ((result.stdout + '').split /\r\n|\n/).pop()
            result = JSON.parse result
            error  = result.error
            if error
                throw new Error 'while executing forc-func.sync:\n' + error.stack
        catch e
            throw new Error 'while executing forc-func.sync:\n' + error.stack

        result.value


    pimp = (obj, nameOrPath, pathOrAsync, async) ->
        if pathOrAsync and pathOrAsync == pathOrAsync + ''
            key  = nameOrPath
            path = pathOrAsync
        else
            path  = nameOrPath
            async = pathOrAsync

        opts = parse path
        key  = translate key or opts.name or Path.basename opts.path

        if async == false
            obj[key] = (args...) ->
                call opts.path, opts.name, args, null, async
        else
            obj[key] = (args..., callback) ->
                call opts.path, opts.name, args, callback, async
        obj




    call = (path, name, args, callback, async) ->
        if async == false
            path = path + '::' + name if typeof path == 'string' and name
            args.unshift path
            return sync.apply null, args

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

            cp = CP.fork __filename, stdio: ['pipe', 'pipe', 'pipe', 'ipc']
            cp.on 'message', onMessage
            cp.on 'error'  , onError
            cp.on 'exit'   , onExit

            cp.stderr.on 'data', onStdError

            if typeof path == 'function'
                code = path.toString()
                path = null

            cp.send
                path:  path
                name:  name
                code:  code
                args:  args
                async: async

        catch error
            callback error, null
        cp


    parse = (path) ->
        name = null

        if typeof path == 'function'
            return {path: path, name: name}

        if /^[.]?\.\//.test path
            stack = new Error().stack.split /\r\n|\n/
            path  = Path.join Path.dirname(/\((.*?):/.exec(stack[3])[1]), path

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
    ForkFunc.sync    = sync
    ForkFunc.pimp    = pimp
    ForkFunc.default = ForkFunc # stupid hack to get ts default exports working


    module.exports = ForkFunc


else


    #     0000000  000   000  000  000      0000000  
    #    000       000   000  000  000      000   000
    #    000       000000000  000  000      000   000
    #    000       000   000  000  000      000   000
    #     0000000  000   000  000  0000000  0000000

    args = process.argv

    if args.length == 3 and args[1] == __filename
        opts = JSON.parse args[2]
        path = opts.path
        name = opts.name
        args = opts.args
        code = opts.code
        try
            if code
                args = JSON.stringify args
                eval "value = (#{code}).apply(null, #{args});"
            else
                func  = require path
                func  = func[name] if name and name != 'null'
                value = func.apply null, args
        catch error
            error =
                name:    error.name
                message: error.message
                stack:   error.stack

        result = JSON.stringify
            error: error
            value: value

        process.stdout.write result, 'utf8'

    else

        call = (msg) ->
            try
                if msg.code
                    args = JSON.stringify msg.args
                    if msg.async
                        args = args.slice(0, -1) + ', ' + ready.toString() + ']'
                    eval "result = (#{msg.code}).apply(null, #{args});"
                    ready null, result if not msg.async
                else
                    func = require msg.path
                    func = func[msg.name] if msg.name
                    msg.args.push ready   if msg.async
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







