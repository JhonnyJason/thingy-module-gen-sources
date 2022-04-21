##############################################################################
#region debug
import {createLogFunctions} from "thingy-debug"
{log, olog} = createLogFunctions("generateprocessmodule")

#endregion

##############################################################################
#region imports
import c from 'chalk'

##############################################################################
import * as userInquiry from "userinquirymodule.js"
import * as pathHandler from "pathhandlermodule.js"
import * as modulegen from "modulegenmodule.js"

#endregion

##############################################################################
successMessage = (arg) -> console.log(c.green(arg))

##############################################################################
export execute = (name, path) ->
    log "execute"
    await pathHandler.checkPaths(name, path)
    successMessage(" Module " + name + " may be created!")
    files = await userInquiry.doInquiry()
    await modulegen.generate(files, name)
    return true
