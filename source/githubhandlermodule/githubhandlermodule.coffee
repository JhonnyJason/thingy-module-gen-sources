githubhandlermodule = {name: "githubhandlermodule"}

OctokitREST = require("@octokit/rest")
inquirer = require("inquirer")
chalk       = require('chalk')
CLI         = require('clui')
Spinner     = CLI.Spinner

#log Switch
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["githubhandlermodule"]?  then console.log "[githubhandlermodule]: " + arg
    return

#region internal variables
octokit = null

authQuestions = [ 
    {
        name: "username"
        type: "input"
        message: "Github username:"
        validate: (value) ->
            if value.length then return true;
            else return 'Please!'   
    },
    {
        name: "password"
        type: "password"
        message: "Github password:"
        validate: (value) ->
            if value.length then return true;
            else return 'Please!'   
    }    
]

twoFactorAuthentification = [
    {
        name: "twoFactorAuthenticationCode"
        type: "input"
        message: "2fa Code:"
        validate: (value) ->
            if value.length then return true;
            else return 'Please!'
    }
]
#endregion

#region exposed variables
githubhandlermodule.user = ""
githubhandlermodule.password = ""
#endregion

##initialization function  -> is automatically being called!  ONLY RELY ON DOM AND VARIABLES!! NO PLUGINS NO OHTER INITIALIZATIONS!!
githubhandlermodule.initialize = () ->
    log "githubhandlermodule.initialize"
    
#region internal functions
buildOctokit = ->    
    authenticated = false
    
    while !authenticated
        answers = await inquirer.prompt(authQuestions)
        status = new Spinner('Checking credentials...');
        
        options =
            auth:
                username: answers.username
                password: answers.password
                on2fa: -> 
                    status.stop()
                    answer = await inquirer.prompt(twoFactorAuthentification)
                    status.start()
                    return answer.twoFactorAuthenticationCode
            userAgent:"thingycreate v0.1.0",
            baseUrl: "https://api.github.com"

        octokit = new OctokitREST(options)
        try
            status.start();
            info = await octokit.users.getAuthenticated()
            console.log(chalk.green("Credentials Check succeeded!"))
            githubhandlermodule.user = answers.username
            githubhandlermodule.password = answers.password
            authenticated = true
        catch err
            console.log(chalk.red("Credentials Check failed!"))
        finally
            status.stop()
#endregion

#region exposed functions
githubhandlermodule.buildConnection = ->
    if (octokit == null)
        await buildOctokit()

githubhandlermodule.assertUserHasNotThatRepo = (repo) ->
    if (octokit == null)
        await buildOctokit()

    try
        await octokit.repos.get({owner:githubhandlermodule.user, repo:repo})
        throw "Repository: " + repo + " did Exist for user:" + githubhandlermodule.user + "!"
    catch err
        if(err.status == 404)
            return
        throw err

githubhandlermodule.checkIfUserHasRepo= (repo) ->
    if(octokit == null)
        await buildOctokit()

    status = new Spinner("Checking if repo exists (" + githubhandlermodule.user + "/" + repo + ")...")
    try
        status.start()
        await octokit.repos.get({owner:githubhandlermodule.user, repo:repo})
        return true
    catch err
        return "Repository " + githubhandlermodule.user + "/" + repo + " does not exist!"
    finally
        status.stop()

githubhandlermodule.createRepository = (repo) ->
    if (octokit == null)
        await buildOctokit()

    result = await octokit.repos.createForAuthenticatedUser({name:repo, private:true})

githubhandlermodule.deleteUserRepository = (repo) ->
    if (octokit == null)
        await buildOctokit()
    
    result = await octokit.repos.delete({owner:githubhandlermodule.user,repo:repo})
    #console.log(result)

#endregion

module.exports = githubhandlermodule