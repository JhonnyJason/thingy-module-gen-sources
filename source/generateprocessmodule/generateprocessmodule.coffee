##############################################################################
#region debug
import {createLogFunctions} from "thingy-debug"
{log, olog} = createLogFunctions("generateprocessmodule")

#endregion

##############################################################################
#region imports
import c from 'chalk'

##############################################################################
import * as ui from "./userinquirymodule.js"
import * as ph from "./pathhandlermodule.js"
import * as mg from "./modulegenmodule.js"

#endregion

##############################################################################
successMessage = (arg) -> console.log(c.green(arg))

##############################################################################
export execute = (name, path) ->
    log "execute"
    await ph.checkPaths(name, path)
    successMessage(" Module " + name + " may be created!")
    files = await ui.doInquiry()
    await mg.generate(files, name)
    return true
