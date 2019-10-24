configmodule = {name: "configmodule"}

configmodule.secret = {}
configmodule.public = {}


try
    publicConfig = require("./publicConfig.json")
    Object.assign(configmodule.public, publicConfig)
catch err
    console.error(err.message)

try
    secretConfig = require("./secretConfig.json")
    Object.assign(configmodule.secret, secretConfig)
catch err




#log Switch
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["configmodule"]?  then console.log "[configmodule]: " + arg
    return

##initialization function  -> is automatically being called!  ONLY RELY ON DOM AND VARIABLES!! NO PLUGINS NO OHTER INITIALIZATIONS!!
configmodule.initialize = () ->
    log "configmodule.initialize"
    
module.exports = configmodule