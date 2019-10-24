pathhandlermodule = {name: "pathhandlermodule"}

#region node_modules
inquirer    = require("inquirer")
git         = require("simple-git") 
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
utl = null
thingyName = ""
#endregion

#region exposed variables
pathhandlermodule.basePath = ""
pathhandlermodule.thingyPath = ""
#endregion


##initialization function  -> is automatically being called!  ONLY RELY ON DOM AND VARIABLES!! NO PLUGINS NO OHTER INITIALIZATIONS!!
pathhandlermodule.initialize = () ->
    log "pathhandlermodule.initialize"
    utl = allModules.utilmodule

#region internal functions
checkDirectoryExists = (path) ->
    try
        stats = await fs.lstat(path)
        return stats.isDirectory()
    catch err
        # console.log(c.red(err.message))
        return false

checkDirectoryIsInGit = (path) ->
    try
        await utl.execGitCheckPromise(path)
        return true
    catch err
        # console.log(c.red(err.message))
        return false
#endregion

#region exposed functions
pathhandlermodule.tryUse = (providedPath) ->
    if providedPath
        if pathModule.isAbsolute(providedPath)
            pathhandlermodule.basePath = providedPath
        else
            pathhandlermodule.basePath = pathModule.resolve(process.cwd(), providedPath)
    else
        pathhandlermodule.basePath = process.cwd()

    exists = await checkDirectoryExists(pathhandlermodule.basePath)

    if !exists
        throw new Error("Provided directory does not exist!")

    isInGit = await checkDirectoryIsInGit(pathhandlermodule.basePath)
    if isInGit
        throw new Error("Provided directory is already in a git subtree!")

pathhandlermodule.checkCreatability = (directoryName) ->
    directoryPath = pathModule.resolve(pathhandlermodule.basePath, directoryName)
    exists = await checkDirectoryExists(directoryPath)
    if exists
        throw "The directory at " + directoryPath + " already exists!"

pathhandlermodule.createInitializationBase = (name) ->
    thingyName = name
    pathhandlermodule.thingyPath = pathModule.resolve(pathhandlermodule.basePath, thingyName)
    pathhandlermodule.basePath = pathModule.resolve(pathhandlermodule.basePath, name + "-init")
    await fs.mkdirs(pathhandlermodule.basePath)

pathhandlermodule.cleanInitializationBase = () ->
    initializedThingyPath = pathModule.resolve(pathhandlermodule.basePath, thingyName)
    await fs.move(initializedThingyPath, pathhandlermodule.thingyPath)
    await fs.remove(pathhandlermodule.basePath)
    pathhandlermodule.basePath = pathModule.resolve(pathhandlermodule.basePath, "..")

pathhandlermodule.getBasePath = () ->
    return pathhandlermodule.basePath

pathhandlermodule.getGitPaths = (name) ->
    r = {}
    r.repoDir = pathModule.resolve(pathhandlermodule.basePath, name)
    r.gitDir = pathModule.resolve(r.repoDir, ".git")
    return r

pathhandlermodule.getLicenseSourcePaths = () ->
    r =  {}
    r.licensePath = pathModule.resolve(__dirname, "../LICENSE")
    r.unlicensePath = pathModule.resolve(__dirname, "../UNLICENSE")
    return r

pathhandlermodule.getLicenseDestinationPaths = (repoDir) ->
    r =  {}
    r.licensePath = pathModule.resolve(repoDir, "LICENSE")
    r.unlicensePath = pathModule.resolve(repoDir, "UNLICENSE")
    return r

pathhandlermodule.setThingyPath = (path) ->
    pathhandlermodule.thingyPath = path

pathhandlermodule.getToolsetPath = ()  ->
    return pathModule.resolve(pathhandlermodule.thingyPath, "toolset")

pathhandlermodule.getPreparationScriptPath = (scriptFileName) ->
    return pathModule.resolve(pathhandlermodule.thingyPath, "toolset", scriptFileName)

#endregion

module.exports = pathhandlermodule