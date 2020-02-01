{{moduleName}} = {name: "{{moduleName}}"}

#region modulesFromTheEnvironment
#endregion

#region printLogFunctions
##############################################################################
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["{{moduleName}}"]?  then console.log "[{{moduleName}}]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
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