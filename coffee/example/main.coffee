fork = require '../fork-func'


callback = (error, result) ->
    if error
        console.log 'ERROR: ', error
    else
        console.log result


console.log '\nstarting some heavy work ...'

fork './some-heavy-work', 3000, 'background job ready', callback

console.log 'ready ;-) but still working in background ...\n'


console.log 'starting some heavy, nested work ...'

fork './some-heavy-nested-work::work', 3100, 'nested background job ready', callback

console.log 'ready ;-) but still working (nested) in background ...\n'


console.log 'starting some heavy, async work ...'

fork.async './some-heavy-async-work', 3200, 'async background job ready', callback

console.log 'ready ;-) but still working (async) in background ...\n'


pimped = {}


fork.pimp  pimped, __dirname + '/some-heavy-work'
fork.pimp  pimped, './some-heavy-nested-work::work'
fork.pimp  pimped, './some-heavy-async-work', true
fork.pimp  pimped, 'workAsync',  './some-heavy-async-work', true
fork.pimp  pimped, 'workHeavy',  './some-heavy-work'
fork.pimp  pimped, 'workNested', './some-heavy-nested-work::work'


pimped.someHeavyWork      3300, 'called from pimped.someHeavyWork',      callback
pimped.work               3400, 'called from pimped.work',               callback
pimped.someHeavyAsyncWork 3500, 'called from pimped.someHeavyAsyncWork', callback
pimped.workAsync          3600, 'called from pimped.workAsync',          callback
pimped.workHeavy          3700, 'called from pimped.workHeavy',          callback
pimped.workNested         3800, 'called from pimped.workNested',         callback



