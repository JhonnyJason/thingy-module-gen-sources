{{moduleName}} = {name: "{{moduleName}}"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["{{moduleName}}"]?  then console.log "[{{moduleName}}]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
{{moduleName}}.initialize = () ->
    log "{{moduleName}}.initialize"
    return
    
module.exports = {{moduleName}}