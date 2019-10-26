generateprocessmodule = {name: "generateprocessmodule"}

#region node_modules
c       = require('chalk')
#endregion

#log Switch
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["generateprocessmodule"]?  then console.log "[generateprocessmodule]: " + arg
    return

#region internal variables
successMessage = (arg) -> console.log(c.green(arg))

userInquiry = null
pathHandler = null
modulegen = null
#endregion

##initialization function  -> is automatically being called!  ONLY RELY ON DOM AND VARIABLES!! NO PLUGINS NO OHTER INITIALIZATIONS!!
generateprocessmodule.initialize = () ->
    log "generateprocessmodule.initialize"
    userInquiry = allModules.userinquirymodule
    pathHandler = allModules.pathhandlermodule
    modulegen = allModules.modulegenmodule

#region internal functions
#endregion

#region exposed functions
generateprocessmodule.execute = (name, path) ->
    log "generateprocessmodule.execute"
    await pathHandler.checkPaths(name, path)
    successMessage(" Module " + name + " may be created!")
    files = await userInquiry.doInquiry()
    await modulegen.generate(files, name)
    return true
#endregion

module.exports = generateprocessmodule
