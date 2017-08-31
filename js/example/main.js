// Generated by CoffeeScript 1.11.1
(function() {
  var Cmd, Fs, Path, callback, cmd, fork, getCfg, path, pimped, result, someHeavyAsyncWork, someHeavyWork;

  Fs = require('fs');

  Path = require('path');

  fork = require('../fork-func');

  pimped = {};

  Cmd = require('./test');

  cmd = new Cmd();

  cmd.execute('hello');

  path = Path.join(__dirname, 'cfg.js');

  Fs.writeFileSync(path, 'module.exports = {hello:"world"};');

  console.log('cfg: ', require(path));

  Fs.writeFileSync(path, 'module.exports = {hello:"world!!!"};');

  delete require.cache[path];

  console.log('cfg: ', require(path));

  getCfg = function(path) {
    return require(path);
  };

  Fs.writeFileSync(path, 'module.exports = {hello:"world"};');

  console.log('cfg: ', fork.sync(getCfg, path));

  Fs.writeFileSync(path, 'module.exports = {hello:"world ;-)"};');

  console.log('cfg: ', fork.sync(getCfg, path));

  someHeavyWork = function(delay, msg) {
    var start;
    start = Date.now();
    while (Date.now() - start < delay) {
      null;
    }
    return delay + 'ms later ... ' + msg;
  };

  someHeavyAsyncWork = function(delay, msg, done) {
    return setTimeout(function() {
      return done(null, delay + 'ms later ... ' + msg);
    }, delay);
  };

  callback = function(error, result) {
    if (error) {
      return console.log('ERROR: ', error);
    } else {
      return console.log(result);
    }
  };

  console.log('\ncalling sync ...');

  console.log(result = fork.sync('./some-heavy-work', 1000, 'result from sync call\n'));

  console.log('calling real function sync ...');

  console.log(result = fork.sync(someHeavyWork, 1000, 'result from sync real function call\n'));

  fork.pimp(pimped, 'workSync', __dirname + '/some-heavy-work', false);

  console.log('calling pimped.workSync ...');

  console.log(result = pimped.workSync(1000, 'result from pimped.workSync\n'));

  console.log('call real function ...');

  fork(someHeavyWork, 1000, 'real function ready', callback);

  console.log('ready ;-) but real function keeps running ...\n');

  console.log('call real function async ...');

  fork.async(someHeavyAsyncWork, 1100, 'async real function ready', callback);

  console.log('ready ;-) but async real function keeps running ...\n');

  console.log('starting some heavy work ...');

  fork('./some-heavy-work', 3000, 'background job ready', callback);

  console.log('ready ;-) but still working in background ...\n');

  console.log('starting some heavy, nested work ...');

  fork('./some-heavy-nested-work::work', 3100, 'nested background job ready', callback);

  console.log('ready ;-) but still working (nested) in background ...\n');

  console.log('starting some heavy, async work ...');

  fork.async('./some-heavy-async-work', 3200, 'async background job ready', callback);

  console.log('ready ;-) but still working (async) in background ...\n');

  fork.pimp(pimped, __dirname + '/some-heavy-work');

  fork.pimp(pimped, './some-heavy-nested-work::work');

  fork.pimp(pimped, './some-heavy-async-work', true);

  fork.pimp(pimped, 'workAsync', './some-heavy-async-work', true);

  fork.pimp(pimped, 'workHeavy', './some-heavy-work');

  fork.pimp(pimped, 'workNested', './some-heavy-nested-work::work');

  pimped.someHeavyWork(3300, 'called from pimped.someHeavyWork', callback);

  pimped.work(3400, 'called from pimped.work', callback);

  pimped.someHeavyAsyncWork(3500, 'called from pimped.someHeavyAsyncWork', callback);

  pimped.workAsync(3600, 'called from pimped.workAsync', callback);

  pimped.workHeavy(3700, 'called from pimped.workHeavy', callback);

  pimped.workNested(3800, 'called from pimped.workNested', callback);

}).call(this);
