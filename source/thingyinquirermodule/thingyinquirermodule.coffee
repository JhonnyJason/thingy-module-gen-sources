thingyinquirermodule = {name: "thingyinquirermodule"}

#region node_modules
inquirer = require("inquirer")
#endregion


#log Switch
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["thingyinquirermodule"]?  then console.log "[thingyinquirermodule]: " + arg
    return

#region internal variables
utl = null
github = null
githubRemoteHandler = null
#endregion

#region exposed variables
#endregion


##initialization function  -> is automatically being called!  ONLY RELY ON DOM AND VARIABLES!! NO PLUGINS NO OHTER INITIALIZATIONS!!
thingyinquirermodule.initialize = () ->
    log "thingyinquirermodule.initialize"
    utl = allModules.utilmodule
    github = allModules.githubhandlermodule
    githubRemoteHandler = allModules.githubremotehandlermodule

#region internal functions
createTypeQuestion = (allTypes) ->
    allTypesFancy = (utl.capitaliseFirstLetter(type) for type in allTypes)
    return [
        {
            name: "thingyType",
            type: "list",
            message: "...creating what type of thingy?",
            choices: allTypesFancy,
            default: allTypesFancy[0]
        }
    ]

createNameQuestion = -> 
    return [
        {
            name: "thingyName",
            type: "input",
            message: "What is the name of the thingy?",
            validate: (value) ->
                if value.length then return true
                else return 'Please enter a name for the thingy!';
        }
    ]

generateRepoOptions = (templateURL, defaultBehaviour, negotiableBehaviours) ->
    options = []

    if templateURL
        if defaultBehaviour != "create"
            options.push(defaultBehaviour + " " + templateURL)
        
        if negotiableBehaviours[0] and (negotiableBehaviours[0] != "create")
            options.push(negotiableBehaviours[0] + " " + templateURL)
        if negotiableBehaviours[1] and (negotiableBehaviours[1] != "create")
            options.push(negotiableBehaviours[1] + " " + templateURL)
        if negotiableBehaviours[2] and (negotiableBehaviours[2] != "create")
            options.push(negotiableBehaviours[2] + " " + templateURL)
 
    options.push(defaultBehaviour + " " + "new")

    
    if negotiableBehaviours[0]
        options.push(negotiableBehaviours[0] + " " + "new")
    if negotiableBehaviours[1]
        options.push(negotiableBehaviours[1] + " " + "new")
    if negotiableBehaviours[2]
        options.push(negotiableBehaviours[2] + " " + "new")
    
    return options

createRepositoryQuestion = (node) ->
    # console.log("\nShould ask about new node:")
    # console.log(JSON.stringify(node, null, 4))
    options = generateRepoOptions(node.templateURL, node.defaultBehaviour, node.negotiableBehaviours)
    # console.log(options)
    if options.length == 1 
        node.answers =
            option: options[0]
        return []

    return [
        {
            name: "option",
            type: "list",
            message: "'" + node.repo  + "' - repository...  How shall it be initialized?",
            choices: options,
            default: options[0]
        },
        {
            type: 'input',
            name: 'newRepo',
            message: "What repository to take?",
            validate: (value) ->
                if value.length
                    if utl.isFullURL(value)
                        providedRemote = githubRemoteHandler.createRemoteFromURL(value)
                        return providedRemote.checkReachability()
                    else return github.checkIfUserHasRepo(value)             
                else return 'Please!'   
            when: (answers) ->
                if answers.option.indexOf("create") == 0 then return false
                if answers.option.indexOf("new") == (answers.option.length - 3) then return true
                return false
        }
    ]
#endregion

#region exposed functions
thingyinquirermodule.inquireThingyType =  (allTypes) ->
    typeQuestion = createTypeQuestion(allTypes)
    answer = await inquirer.prompt(typeQuestion)
    return answer.thingyType
 
thingyinquirermodule.inquireThingyName = ->
    nameQuestion = createNameQuestion()
    answer = await inquirer.prompt(nameQuestion)
    return answer.thingyName

thingyinquirermodule.inquireRepositoryTreatment = (node) ->
    repositoryQuestion = createRepositoryQuestion(node)
    answers = await inquirer.prompt(repositoryQuestion)
    return answers
#endregion

module.exports = thingyinquirermodule