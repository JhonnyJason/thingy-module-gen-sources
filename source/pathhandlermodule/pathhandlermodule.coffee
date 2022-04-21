##############################################################################
#region debug
import {createLogFunctions} from "thingy-debug"
{log, olog} = createLogFunctions("pathhandlermodule")

#endregion


##############################################################################
#region imports
import c from 'chalk'
import fs from "fs-extra"
import pathModule  from "path"

#endregion

##############################################################################
#region variables
sourcePath = ""
modulePath = ""
thingyPath = ""

#endregion

##############################################################################
#region internal functions
checkDirectoryExists = (path) ->
    try
        stats = await fs.lstat(path)
        return stats.isDirectory()
    catch err
        # console.log(c.red(err.message))
        return false


##############################################################################
findSourcePath = ->
    log "findSourcePath"

    sourcePath = pathModule.resolve(thingyPath, "sources/source")
    exists = await checkDirectoryExists(sourcePath)
    if !exists
        throw new Error("sourcePath: " + sourcePath + " did not exist! The provided path might not be the thingy root.")
    sourcePath = sourcePath

findModulePath = (name) ->
    log "findModulePath"
    modulePath = pathModule.resolve(sourcePath, name)
    exists = await checkDirectoryExists(modulePath)
    if exists
        throw new Error("modulePath: " + modulePath + " did already exist!")
    modulePath = modulePath

##############################################################################
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
    
    thingyPath = providedPath

#endregion

##############################################################################
#region exports
export checkPaths = (name, providedPath) ->
    log "checkPaths"

    log "checking for providedPath: " + providedPath
    await checkProvidedPath(providedPath)
    log "resulting thingy path is: " + thingyPath
    
    await findSourcePath()
    await findModulePath(name)

export getModulePath = -> modulePath

export getSourcePath = -> sourcePath

#endregion