debugmodule = {name: "debugmodule"}

##initialization function  -> is automatically being called!  ONLY RELY ON DOM AND VARIABLES!! NO PLUGINS NO OHTER INITIALIZATIONS!!
debugmodule.initialize = () ->
    # console.log "debugmodule.initialize - nothing to do"
    return

debugmodule.modulesToDebug = 
    unbreaker: true
    # cliargumentsmodule: true
    # configmodule: true
    # generateprocessmodule: true
    # modulegenmodule: true
    # pathhandlermodule: true
    # startupmodule: true
    # userinquirymodule: true
    # utilmodule: true

#region exposed variables

module.exports = debugmodule