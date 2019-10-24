createprocessmodule = {name: "createprocessmodule"}

#log Switch
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["createprocessmodule"]?  then console.log "[createprocessmodule]: " + arg
    return

#region internal variables
github = null
repositoryTree = null
thingy = null
pathHandler = null
cfg = null
#endregion

##initialization function  -> is automatically being called!  ONLY RELY ON DOM AND VARIABLES!! NO PLUGINS NO OHTER INITIALIZATIONS!!
createprocessmodule.initialize = () ->
    log "createprocessmodule.initialize"
    github = allModules.githubhandlermodule
    repositoryTree = allModules.repositorytreehandlermodule
    thingy = allModules.thingymodule
    pathHandler = allModules.pathhandlermodule
    cfg = allModules.configmodule

#region internal functions
useArguments = (arg1, arg2) ->
    if(typeof arg1 == "string")
        thingy.setType(arg1)

    if(typeof arg2 == "string")
        thingy.setName(arg2)

#endregion

#region exposed functions
createprocessmodule.execute = (arg1, arg2, path) ->
        thingy.digestConfig(cfg.public.thingies)
        useArguments(arg1, arg2)
        await pathHandler.tryUse(path)
        await github.buildConnection()
        await thingy.doUserInquiry()
        thingy.createRepositoryTree()
        await repositoryTree.initializeRepositories()
        await thingy.prepare()
        return true
#endregion

module.exports = createprocessmodule
