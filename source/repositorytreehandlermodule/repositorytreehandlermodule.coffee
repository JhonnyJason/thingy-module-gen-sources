repositorytreehandlermodule = {name: "repositorytreehandlermodule"}

#region node_modules
CLI         = require('clui');
Spinner     = CLI.Spinner;
c           = require("chalk")
git         = require("simple-git/promise")
fs          = require("fs-extra")
#endregion

#log Switch
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["repositorytreehandlermodule"]?  then console.log "[repositorytreehandlermodule]: " + arg
    return

#region internal variables
githubRemoteHandler = null
github = null
pathHandler = null
cfg = null
utl = null

treeRoot = null
#endregion

#region exposed variables
#endregion


##initialization function  -> is automatically being called!  ONLY RELY ON DOM AND VARIABLES!! NO PLUGINS NO OHTER INITIALIZATIONS!!
repositorytreehandlermodule.initialize = () ->
    log "repositorytreehandlermodule.initialize"
    githubRemoteHandler = allModules.githubremotehandlermodule
    github = allModules.githubhandlermodule
    pathHandler = allModules.pathhandlermodule
    cfg = allModules.configmodule
    utl = allModules.utilmodule

#region classes
class RepositoryNode
    constructor: (constructorObject) ->
        Object.assign(this, constructorObject)
        
        if !@remote
            if @owner and  @repo
                @remote = githubRemoteHandler.createRemote(@owner, @repo)
        else if !@repo or !@owner
            @repo = @remote.getRepo()
            @owner = @remote.getOwner()

        if @sourceRemote 
            @toBeCopied = true
            @initialized = false
            @repositoryType = "NewCopiedRepository"
        else if @initialized    
            @repositoryType = "UsedRepository"
        else
            @initialized = false
            @repositoryType = "NewRepository"

        
        if (!@remote) and (!@repo or !@owner)
            @repositoryType = "NoRepository"

        if !@name
            @name = @repo

        if !@name
            throw new Error("Bug!! There is no name for the directory of the repository!")

        @submodules = []
        # console.log(c.green("\nAfter Constructor Ran:"))
        # console.log(c.yellow(JSON.stringify(this, null, 2)))

    getRemote: -> @remote

    getRepo: -> @repo

    getName: -> @name

    addSubrepository: (node) ->
        # console.log(" -   - - - - - -  - - -")
        # console.log("at " + @repo)
        # console.log(" adding submodule: " + node.getRepo())
        @submodules.push(node)

    printToConsole: (prefix) ->
        console.log(prefix + @repo)
        submodule.printToConsole(prefix + "  ") for submodule in @submodules
        return

    getReposToCreate: ->
        repos = []
        
        for submodule in @submodules
            subRepos = submodule.getReposToCreate()
            repos.push(subRepo) for subRepo in subRepos 
                
        if !@initialized
            repos.push(@repo)  
        return repos
 
    initialize: ->
        return if @initialized

        if @isRoot then await pathHandler.createInitializationBase(@name)

        await submodule.initialize() for submodule in @submodules

        base = pathHandler.getBasePath()
        gitPaths = pathHandler.getGitPaths(@name)
        gitDir = gitPaths.gitDir
        repoDir = gitPaths.repoDir
        
        # console.log(c.yellow("Initializing " + @name))
        # console.log(c.yellow("basePath " + base))
        # console.log(c.yellow("repoDir " + repoDir))
        # console.log(c.yellow("gitDir " + gitDir))

        if @toBeCopied
            await git(base).clone(@sourceRemote.getSSH(), @name)
            await fs.remove(gitDir)
        else
            await fs.mkdirs(repoDir)

        await git(repoDir).init()
        await git(repoDir).addRemote("origin", @remote.getSSH())
        
        for submodule in @submodules
            remote = submodule.getRemote().getSSH()
            name = submodule.getName()
            await git(repoDir).submoduleAdd(remote, name)


        source = pathHandler.getLicenseSourcePaths() 
        dest = pathHandler.getLicenseDestinationPaths(repoDir)
        # console.log(c.yellow("copying " + source.unlicensePath + " to " + dest.unlicensePath))
        # console.log(c.yellow("copying " + source.licensePath + " to " + dest.licensePath))
        await fs.copy(source.licensePath, dest.licensePath)
        await fs.copy(source.unlicensePath, dest.unlicensePath)

        await git(repoDir).add(".")
        result = await git(repoDir).commit("initial commit")
        # console.log(c.yellow(JSON.stringify(result, null, 2)))
        # throw "Death on purpose!"
        await git(repoDir).push("origin", "master")

        if !@isRoot then await fs.remove(repoDir)
        else await pathHandler.cleanInitializationBase()
#endregion

#region internal functions
createRepos = (repos) ->
    status = new Spinner("Creating all repositories...")
    try
        status.start()
        promises = (github.createRepository(repo) for repo in repos) 
        await Promise.all(promises)
        console.log(c.green("created!"))
    finally
        status.stop()

# deleteCreatedRepos ->
#     status = new Spinner("Deleting all repositories...")
#     try
#         status.start()
#         promises = (github.deleteUserRepository(repo) for repo in repos)
#         await Promise.all(promises)
#         console.log(c.green("deleted!"))
#     finally
#         status.stop()

#endregion

#region exposed functions
repositorytreehandlermodule.createRootRepository = (rootNode) ->
    # console.log(JSON.stringify(rootNode, null, 4))
    constructorObject =
        repo: rootNode.repo
        owner: github.user
        sourceRemote: rootNode.sourceRemote
        isRoot: true
    treeRoot = new  RepositoryNode(constructorObject)
    return

repositorytreehandlermodule.getRootRepository = -> treeRoot

repositorytreehandlermodule.createRepositoryNode = (node) ->
    constructorObject =
        name: node.name
        repo: node.repo
    if node.initialized
        constructorObject.remote = node.sourceRemote
        constructorObject.initialized = true
    else
        constructorObject.owner = github.user
        constructorObject.sourceRemote = node.sourceRemote
    return new RepositoryNode(constructorObject)

repositorytreehandlermodule.initializeRepositories = ->
    status = new Spinner("Initializing all repositories...")
    try
        status.start()
        reposToCreate = treeRoot.getReposToCreate()
        # console.log(reposToCreate)
        await createRepos(reposToCreate)
        await treeRoot.initialize()
        console.log(c.green("initialized!"))
    finally
        status.stop()

repositorytreehandlermodule.printRepositoryTree = ->
    console.log("\nRepository Tree:")
    treeRoot.printToConsole(">")

#endregion

module.exports = repositorytreehandlermodule