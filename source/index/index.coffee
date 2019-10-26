Modules = require "./allmodules.js"

global.allModules = Modules

run = ->
    try
        promises = (m.initialize() for n,m of Modules )
        await Promise.all(promises)
        await Modules.startupmodule.cliStartup()
    catch err
        console.log("Catched error in outmost level:")
        console.log err
        process.exit(-1)

run()