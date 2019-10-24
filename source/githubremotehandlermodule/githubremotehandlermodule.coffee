githubremotehandlermodule = {name: "githubremotehandlermodule"}

#region node_modules imports
CLI         = require('clui')
Spinner     = CLI.Spinner
request     = require("request-promise")
c           = require("chalk")
#endregion

#log Switch
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["githubremotehandlermodule"]?  then console.log "[githubremotehandlermodule]: " + arg
    return

#region internal variables
github = null

minURLLength = 20
githubSSHBase = "git@github.com"
githubHTTPSBase = "https://github.com"
#endregion

#region exposed variables
#endregion


##initialization function  -> is automatically being called!  ONLY RELY ON DOM AND VARIABLES!! NO PLUGINS NO OHTER INITIALIZATIONS!!
githubremotehandlermodule.initialize = () ->
    log "githubremotehandlermodule.initialize"
    github = allModules.githubhandlermodule

#region classes
class githubRemoteObject
    constructor: (@owner, @repoName) ->
        @httpsURL = githubHTTPSBase + "/" + @owner + "/" + @repoName + ".git"
        @sshURL = githubSSHBase + ":" + @owner + "/" + @repoName + ".git"
        @reachability = false
        @reachabilityChecked = false

    checkReachability: ->
        options =
            method: 'HEAD',
            uri: this.httpsURL
        status = new Spinner("Checking if " + this.httpsURL + " is reachable...")
        try
            status.start()
            await request(options)
            console.log(c.green("Reachable!"))
            @reachability = true
            return true
        catch err
            console.log(c.red("Not Reachable!"))
            @reachability = false
            return false
        finally
            status.stop()
            @reachabilityChecked = true

    getOwner: -> @owner

    getRepo: -> @repoName

    getHTTPS: -> @httpsURL

    getSSH: -> @sshURL

    isReachable: ->
        if !@reachabilityChecked
            console.log(c.yellow("warning! reachability has not been checked yet!"))
        return @reachability
#endregion

#region internal functions
extractRepoDataFromURL = (url) ->
    repo = {}
    if typeof url != "string"
        throw new Error("URL to Extract Repo from not a string!")
    if !url
        throw new Error("URL to Extract Repo from was an empty String!")
    if url.length < minURLLength 
        throw new Error("URL to Extract Repo was smaller than the minimum of " + minURLLength + " characters!")
    endPoint = url.lastIndexOf(".")
    if endPoint < 0
        throw new Error("Unexpectd URL for github repository: " + url)
    lastSlash = url.lastIndexOf("/")
    if lastSlash < 0
        throw new Error("Unexpectd URL for github repository: " + url)
    repo.repoName = url.substring(lastSlash + 1, endPoint)
    checker = url.substr(0,8)
    if checker == "https://"
        secondLastSlash = url.lastIndexOf("/", lastSlash - 1)
        if (secondLastSlash < 8)
            throw new Error("Unexpectd URL for github repository: " + url)
        repo.owner = url.substring(secondLastSlash + 1, lastSlash)
    else if checker == "git@gith"
        lastColon = url.lastIndexOf(":", lastSlash - 1)
        if lastColon < 14
            throw new Error("Unexpectd URL for github repository: " + url)
        repo.owner = url.substring(lastColon + 1, lastSlash)
    else
        throw new Error("Unexpectd URL for github repository: " + url)
    return repo
#endregion

#region exposed functions
githubremotehandlermodule.createOwnRemote = (repoName) ->
    return new githubRemoteObject(github.username, repoName)

githubremotehandlermodule.createRemoteFromURL = (url) ->
    repo = extractRepoDataFromURL(url)
    return new githubRemoteObject(repo.owner, repo.repoName)

githubremotehandlermodule.createRemote = (ownerOrURL, repoName) ->
    if repoName
        return new githubRemoteObject(ownerOrURL, repoName)
    else
        repo = extractRepoDataFromURL(ownerOrURL)
        return new githubRemoteObject(repo.owner, repo.repoName)    
#endregion

module.exports = githubremotehandlermodule