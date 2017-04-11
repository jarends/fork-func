fork = require '../fork-func'


callback = (error, result) -> console.log result


console.log '\nstarting some heavy work ...'

fork './some-heavy-work', 3000, 'background job ready', callback

console.log 'ready ;-) but still working in background ...\n'


console.log 'starting some heavy, nested work ...'

fork './some-heavy-nested-work::work', 3100, 'nested background job ready', callback

console.log 'ready ;-) but still working (nested) in background ...\n'


pimped = {}


fork.pimp pimped, __dirname + '/some-heavy-work'
fork.pimp pimped, './some-heavy-nested-work::work'
fork.pimp pimped, 'workHeavy',  './some-heavy-work'
fork.pimp pimped, 'workNested', './some-heavy-nested-work::work'


pimped.someHeavyWork 3200, 'called from pimped.someHeavyWork', callback
pimped.work          3300, 'called from pimped.work',          callback
pimped.workHeavy     3400, 'called from pimped.workHeavy',     callback
pimped.workNested    3500, 'called from pimped.workNested',    callback



