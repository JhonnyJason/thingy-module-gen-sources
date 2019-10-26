hookupmodule = {name: "hookupmodule"}

#log Switch
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["hookupmodule"]?  then console.log "[hookupmodule]: " + arg
    return

##initialization function  -> is automatically being called!  ONLY RELY ON DOM AND VARIABLES!! NO PLUGINS NO OHTER INITIALIZATIONS!!
hookupmodule.initialize = () ->
    log "hookupmodule.initialize"
    return

#region exposed functions
hookupmodule.hookUpTheCoffee = (moduleName) ->
    log "hookupmodule.hookUpTheCoffee"
    log "moduleName: " + moduleName
    log "not implemented yet!"

hookupmodule.hookUpTheStyle = (pugname) ->
    log "hookupmodule.hookUpTheStyle"
    log "pugname: " + pugname
    log "not implemented yet!"

#endregion

module.exports = hookupmodule