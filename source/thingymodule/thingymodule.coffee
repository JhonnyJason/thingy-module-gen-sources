thingymodule = {name: "thingymodule"}


#region node_modules
c           = require("chalk")
CLI         = require('clui');
Spinner     = CLI.Spinner;
#endregion

#log Switch
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["thingymodule"]?  then console.log "[thingymodule]: " + arg
    return

#region internal variables
remoteHandler = null
repositoryTreeHandler = null
pathHandler = null
thingyInquirer = null
github = null
utl = null

allThingies = null
allTypes = []
type = ""
typeIndex = -1
name = ""

typeSpecificRepos = null
allRepos = null
#endregion

#region exposed variables
#endregion


##initialization function  -> is automatically being called!  ONLY RELY ON DOM AND VARIABLES!! NO PLUGINS NO OHTER INITIALIZATIONS!!
thingymodule.initialize = () ->
    log "thingymodule.initialize"
    remoteHandler = allModules.githubremotehandlermodule
    repositoryTreeHandler = allModules.repositorytreehandlermodule
    pathHandler = allModules.pathhandlermodule
    thingyInquirer = allModules.thingyinquirermodule
    github = allModules.githubhandlermodule
    utl = allModules.utilmodule


#region internal functions
getPreparationScript = ->
    if typeof type == "string" && type
        t = utl.capitaliseFirstLetter(type)
        return "prepareThingyFor" + t + ".pl"
    else throw new Error("Cannot greate preparation Script without type!")

checkAndAssignType = (newType) ->
    newType = newType.toLowerCase()
    
    typeIndex = -1

    for type, i in allTypes
        if type == newType then typeIndex = i

    if typeIndex < 0 then throw Error("Unexpected Thingy Type: " + newType)

    type = allTypes[typeIndex]

setCurrentThoughtRepos = ->
    allRepos = reposForType()
    if name
        allRepos.unshift(name)
        typeSpecificRepos = reposForType()
    else typeSpecificRepos = allRepos

    # console.log("allRepos")
    # console.log(allRepos)
    # console.log("typeSpecificRepos")
    # console.log(typeSpecificRepos)

extractAllPostfixes = (thingy) ->
    # console.log("extracting all Postfixes for: ")
    # console.log(JSON.stringify(thingy, null, 4))
    result = []    
    for submodule in thingy.submodules
        result = result.concat(extractAllPostfixes(submodule))
    
    if thingy.postfix then result.push(thingy.postfix)        
    return result

reposForType = ->
    thingy = allThingies[type]
    allPostfixes = extractAllPostfixes(thingy)
    # console.log("allPostfixes:")
    # console.log(allPostfixes)

    repos = (name + postfix for postfix in allPostfixes)
    # console.log("corresponding repos:")
    # console.log(repos)
    return repos

createChildPairings = (child) ->
    return
        node: child,
        treeNode: repositoryTreeHandler.createRepositoryNode(child)

recurseInitChildren = (node, treeParent) ->
    # console.log("node: " + node.repo)
    childPairings = node.submodules.map(createChildPairings)

    for pairing in childPairings
        treeParent.addSubrepository(pairing.treeNode) 
        recurseInitChildren(pairing.node, pairing.treeNode)
    
retrieveAcceptableThingyName = ->
    acceptable = false
    newName = name
    while !acceptable
        if !newName
            newName = await thingyInquirer.inquireThingyName()
            thingymodule.setName(newName)
        status = new Spinner('Checking thingy name "' + newName + '"...');
        try
            status.start()
            await pathHandler.checkCreatability(newName)
            await pathHandler.checkCreatability(newName + "-init")
            promises = (github.assertUserHasNotThatRepo(repo) for repo in allRepos)
            await Promise.all(promises)
            console.log(c.green(" acceptable!"))
            console.log(c.green("All relevant repositories for " + newName + " may be created :-)"))
            acceptable = true
        catch err
            console.log(c.red(" unacceptable!"))
            console.log(c.red(err))
            newName = ""
        finally
            status.stop()


retrieveRepositoryAnswers = (node) ->
    repoURL = node.templateURL
    defaultRemote = null
    node.repo = name + node.postfix    
    
    # console.log("retrieveing Repository Answers for: " + node.repo)
    if repoURL then defaultRemote = remoteHandler.createRemoteFromURL(repoURL)
    
    try if defaultRemote then await defaultRemote.checkReachability()
    catch err then node.templateURL = ""

    answers = await thingyInquirer.inquireRepositoryTreatment(node)
    if answers.option then node.answers = answers
    digestAnswerForNode(node)

    for submodule in node.submodules
        await retrieveRepositoryAnswers(submodule)
    return    

digestAnswerForNode = (node) ->
    answers = node.answers
    tokens = answers.option.split(" ")
    sourceRemote = null
    initialized = false
    
    if tokens[0] == "create" then return

    if tokens[1] == "new"
        if utl.isFullURL(answers.newRepo)
            sourceRemote = remoteHandler.createRemoteFromURL(answers.newRepo)
        else sourceRemote = remoteHandler.createOwnRemote(answers.newRepo)
    else sourceRemote = remoteHandler.createRemoteFromURL(tokens[1])
    
    if tokens[0] == "use" then initialized = true
    node.sourceRemote = sourceRemote
    node.initialized = initialized
    return
#endregion

#region exposed functions
thingymodule.digestConfig = (thingies) ->
    allThingies = thingies
    allTypes = Object.keys(thingies)

thingymodule.setType = (newType) ->
    checkAndAssignType(newType)
    setCurrentThoughtRepos()
thingymodule.setName = (newName) ->
    name = newName
    setCurrentThoughtRepos()

thingymodule.getType = -> type
thingymodule.getName = -> name
thingymodule.hasName = -> (typeof name == "string") or name 
thingymodule.getRepos = -> allRepos

thingymodule.doUserInquiry = ->
    if !type
        inquiredType = await thingyInquirer.inquireThingyType(allTypes)
        thingymodule.setType(inquiredType)
    
    # console.log(c.yellow("type: " + type))
    # console.log(c.yellow("having name: " + name))
    # console.log(c.yellow("having allRepos"))
    # console.log(allRepos)
    
    await retrieveAcceptableThingyName()

    # console.log(c.yellow("now we have the name: " + name))
    # console.log(c.yellow("having allRepos"))
    # console.log(allRepos)
    await retrieveRepositoryAnswers(allThingies[type])
    # console.log(JSON.stringify(allThingies[type], null, 4))
    # throw "Death on purpose!"
            
    # await getToolsetRepo()
    # await getSourceRepo()

thingymodule.prepare = ->
    scriptFileName = getPreparationScript()
    scriptPath = pathHandler.getPreparationScriptPath(scriptFileName)         
    options =
        cwd: pathHandler.getToolsetPath()

    # console.log(c.yellow("preparationScriptPath: " + scriptPath))
    # console.log(c.yellow("exec options: " + JSON.stringify(options, null, 2)))

    console.log(c.green("Running " + scriptPath))
    output = await utl.execScriptPromise(scriptPath, options)
    console.log(c.green(output))

thingymodule.createRepositoryTree = ->
    #TODO update this
    if name
        thingyRootNode = allThingies[type]
        repositoryTreeHandler.createRootRepository(thingyRootNode)
        treeRootNode = repositoryTreeHandler.getRootRepository()
        recurseInitChildren(thingyRootNode, treeRootNode)
    else throw new Error("Trying to create the RepositoryTree while we don't even have a thingy name...")
    # repositoryTreeHandler.printRepositoryTree()
    return

#endregion

module.exports = thingymodule