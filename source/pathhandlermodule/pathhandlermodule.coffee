pathhandlermodule = {name: "pathhandlermodule"}

#region node_modules
c           = require('chalk');
CLI         = require('clui');
Spinner     = CLI.Spinner;
fs          = require("fs-extra")
pathModule  = require("path")
#endregion

#log Switch
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["pathhandlermodule"]?  then console.log "[pathhandlermodule]: " + arg
    return

#region internal variables
#endregion

#region exposed variables
pathhandlermodule.sourcePath = ""
pathhandlermodule.modulePath = ""
pathhandlermodule.thingyPath = ""
#endregion

##initialization function  -> is automatically being called!  ONLY RELY ON DOM AND VARIABLES!! NO PLUGINS NO OHTER INITIALIZATIONS!!
pathhandlermodule.initialize = () ->
    log "pathhandlermodule.initialize"

#region internal functions
checkDirectoryExists = (path) ->
    try
        stats = await fs.lstat(path)
        return stats.isDirectory()
    catch err
        # console.log(c.red(err.message))
        return false


findSourcePath = ->
    log "findSourcePath"

    sourcePath = pathModule.resolve(pathhandlermodule.thingyPath, "sources/source")
    exists = await checkDirectoryExists(sourcePath)
    if !exists
        throw new Error("sourcePath: " + sourcePath + " did not exist! The provided path might not be the thingy root.")
    pathhandlermodule.sourcePath = sourcePath

findModulePath = (name) ->
    log "findModulePath"
    modulePath = pathModule.resolve(pathhandlermodule.sourcePath, name)
    exists = await checkDirectoryExists(modulePath)
    if exists
        throw new Error("modulePath: " + modulePath + " did already exist! So the module already exists...")
    pathhandlermodule.modulePath = modulePath

checkProvidedPath = (providedPath) ->
    log "checkProvidedPath"

    if providedPath
        if !pathModule.isAbsolute(providedPath)
            providedPath = pathModule.resolve(process.cwd(), providedPath)
    else
        providedPath = process.cwd()

    exists = await checkDirectoryExists(providedPath)
    if !exists
        throw new Error("Provided path:'" + providedPath + "' does not exist!")
    
    pathhandlermodule.thingyPath = providedPath

#endregion

#region exposed functions
pathhandlermodule.checkPaths = (name, providedPath) ->
    log "pathhandlermodule.checkPaths"

    log "checking for providedPath: " + providedPath
    await checkProvidedPath(providedPath)
    log "resulting thingy path is: " + pathhandlermodule.thingyPath
    
    await findSourcePath()
    await findModulePath(name)

pathhandlermodule.getModulePath = -> pathhandlermodule.modulePath

pathhandlermodule.getSourcePath = -> pathhandlermodule.sourcePath
#endregion

module.exports = pathhandlermodule