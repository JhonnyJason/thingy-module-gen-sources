##############################################################################
#region debug
import {createLogFunctions} from "thingy-debug"
{log, olog} = createLogFunctions("utilmodule")

#endregion

##############################################################################
import { execFile, exec } from 'child_process'

##############################################################################
#region exports
export isFullURL = (url) ->
    if url.length < 20 then return false
    checker = url.substr(0,8)
    
    if checker == "https://" then return true
    if checker == "git@gith" then return true
    return false

##############################################################################
export capitaliseFirstLetter = (string)  ->
    return string.charAt(0).toUpperCase() + string.slice(1)

##############################################################################
export execScriptPromise = (script, options) ->    
    return new Promise (resolve, reject) ->
        callback = (error, stdout, stderr) ->
            if error then reject(error)
            if stderr then reject(new Error(stderr))
            resolve(stdout)
        execFile(script, options, callback)

##############################################################################
export execGitCheckPromise = (path) ->
    options = 
        cwd: path
    
    return new Promise (resolve, reject) ->
        callback = (error, stdout, stderr) ->
            if error then reject(error)
            if stderr then reject(new Error(stderr))
            resolve(stdout)
        exec("git rev-parse --is-inside-work-tree", options, callback)

#endregion