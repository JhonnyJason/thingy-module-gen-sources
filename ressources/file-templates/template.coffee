{{moduleName}} = {name: "{{moduleName}}"}

#region node_modules
#endregion

##############################################################################
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["{{moduleName}}"]?  then console.log "[{{moduleName}}]: " + arg
    return

##############################################################################
{{moduleName}}.initialize = () ->
    log "{{moduleName}}.initialize"
    return
    
#region internal functions
#endregion

#region exposed functions
#endregion

module.exports = {{moduleName}}