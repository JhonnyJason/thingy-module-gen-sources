debugmodule = {name: "debugmodule"}

##initialization function  -> is automatically being called!  ONLY RELY ON DOM AND VARIABLES!! NO PLUGINS NO OHTER INITIALIZATIONS!!
debugmodule.initialize = () ->
    console.log "debugmodule.initialize - nothing to do"

debugmodule.modulesToDebug = 
    unbreaker: true
    createprocessmodule: true
    githubhandlermodule: true
    githubremotehandlermodule: true
    pathhandlermodule: true
    configmodule: true
    startupmodule: true
    repositorytreehandlermodule: true
    thingyinquirermodule: true
    thingymodule: true
    utilmodule: true

#region exposed variables

module.exports = debugmodule