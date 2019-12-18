{{moduleName}} = {name: "{{moduleName}}"}

#region modulesFromTheEnvironment
#endregion

#region printLogFunctions
##############################################################################
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["{{moduleName}}"]?  then console.log "[{{moduleName}}]: " + arg
    return
print = (arg) -> console.log(arg)
#endregion
##############################################################################
{{moduleName}}.initialize = () ->
    log "{{moduleName}}.initialize"
    return
    
#region internalFunctions
#endregion

#region exposedFunctions
#endregion

module.exports = {{moduleName}}