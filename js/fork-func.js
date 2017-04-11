// Generated by CoffeeScript 1.11.1
(function() {
  var CP, ForkFunc, Path, call, parse, pimp, translate,
    slice = [].slice;

  if (module.parent) {
    CP = require('child_process');
    Path = require('path');
    ForkFunc = function() {
      var args, callback, i, opts, path;
      path = arguments[0], args = 3 <= arguments.length ? slice.call(arguments, 1, i = arguments.length - 1) : (i = 1, []), callback = arguments[i++];
      opts = parse(path);
      return call(opts.path, opts.name, args, callback);
    };
    pimp = function(obj, nameOrPath, path) {
      var key, name, opts;
      if (path) {
        key = nameOrPath;
      } else {
        path = nameOrPath;
      }
      opts = parse(path);
      path = opts.path;
      name = opts.name;
      key = translate(key || name || Path.basename(path));
      obj[key] = function() {
        var args, callback, i;
        args = 2 <= arguments.length ? slice.call(arguments, 0, i = arguments.length - 1) : (i = 0, []), callback = arguments[i++];
        return call(path, name, args, callback);
      };
      return obj;
    };
    call = function(path, name, args, callback) {
      var cp, error, onExit, onMessage;
      try {
        cp = CP.fork(__filename, {
          stdio: 'inherit'
        });
        onMessage = function(msg) {
          var error, result;
          result = msg.result;
          error = msg.error;
          callback(error, result);
          return null;
        };
        onExit = function() {
          cp.removeListener('message', onMessage);
          cp.removeListener('exit', onExit);
          return null;
        };
        cp.on('message', onMessage);
        cp.on('exit', onExit);
        cp.send({
          path: path,
          name: name,
          args: args
        });
      } catch (error1) {
        error = error1;
        console.log('Forked.call ERROR: ', error);
        callback(error, null);
      }
      return cp;
    };
    parse = function(path) {
      var args, name, stack;
      if (/^[.]?\.\//.test(path)) {
        stack = new Error().stack.split(/\r\n|\n/);
        path = Path.join(Path.dirname(/\((.*?):/.exec(stack[3])[1]), path);
      }
      name = null;
      args = /(.*)::(.*)/.exec(path);
      if (args && args.length) {
        path = args[1];
        name = args[2];
      }
      return {
        path: path,
        name: name
      };
    };
    translate = function(key) {
      key = key.replace(/(-(.))/g, function() {
        var args;
        args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
        return args[2].toUpperCase();
      });
      return key;
    };
    ForkFunc.pimp = pimp;
    module.exports = ForkFunc;
  } else {
    call = function(msg) {
      var args, error, func, name, path, result;
      try {
        path = msg.path;
        name = msg.name;
        args = msg.args;
        func = require(path);
        if (name) {
          func = func[name];
        }
        result = func.apply(null, args);
        process.removeListener('message', call);
        return process.send({
          result: result
        });
      } catch (error1) {
        error = error1;
        process.removeListener('message', call);
        return process.send({
          error: error
        });
      }
    };
    process.on('message', call);
  }

}).call(this);
