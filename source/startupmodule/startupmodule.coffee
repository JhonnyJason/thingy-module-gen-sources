##############################################################################
#region debug
import {createLogFunctions} from "thingy-debug"
{log, olog} = createLogFunctions("startupmodule")

#endregion

##############################################################################
#region modulesFromEnvironment
import c from 'chalk'

##############################################################################
import * as gp from "./generateprocessmodule.js"
import * as ca from "./cliargumentsmodule.js"

#endregion

##############################################################################
#region internal variables
errLog = (arg) -> console.log(c.red(arg))
successLog = (arg) -> console.log(c.green(arg))

#endregion

##############################################################################
export cliStartup = ->
    log "cliStartup"
    try
        e = ca.extractArguments()
        done = await gp.execute(e.name, e.thingyPath)
        if done then successLog 'All done!'
        else throw new Error("SyncProcess returned false!")
    catch err
        errLog 'Error!'
        console.log err.message
        console.log "\n"

