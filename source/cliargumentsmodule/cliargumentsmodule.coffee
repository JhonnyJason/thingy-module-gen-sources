cliargumentsmodule = {name: "cliargumentsmodule"}

#region node_modules
meow       = require('meow')
#endregion

#log Switch
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["cliargumentsmodule"]?  then console.log "[cliargumentsmodule]: " + arg
    return

#region internal variables

#endregion

##initialization function  -> is automatically being called!  ONLY RELY ON DOM AND VARIABLES!! NO PLUGINS NO OHTER INITIALIZATIONS!!
cliargumentsmodule.initialize = () ->
    log "cliargumentsmodule.initialize"
    return

#region internal functions
getHelpText = ->
    log "getHelpText"
    return """
        Usage
            $ thingy-module-gen <arg1> <arg2>
    
        Options
            required:
                arg1, --name <module-name>, -n <module-name>
                name of the module to be created                
            
            optional:
                arg2, --thingy-path <path/to/thingy>, -p <path/to/thingy> [default: ./ ]
                path to the root of the thingy. Usually it is cwd. Use it if you call this script from somewhere else.

        TO NOTE:
            The flags will overwrite the flagless argument.
        Examples
            $ thingy-module-gen  new-super-module 
            ...
    """
getOptions = ->
    log "getOptions"
    return {
        flags:
            name:
                type: "string"
                alias: "n"
            thingyPath:
                type: "string"
                alias: "p"
    }

extractMeowed = (meowed) ->
    log "extractMeowed"
    name = ""
    thingyPath = ""

    if meowed.input[0]
        name = meowed.input[0]
    if meowed.input[1]
        thingyPath = meowed.input[1]

    if meowed.flags.name
        name = meowed.flags.name
    if meowed.flags.thingyPath
        thingyPath = meowed.flags.thingyPath

    # introducing the defaults here as they otherwise
    if !thingyPath then thingyPath = "."

    return {name, thingyPath}

throwErrorOnUsageFail = (extract) ->
    log "throwErrorOnUsageFail"
    if !extract.name
        throw "Usage error: obligatory option name was not provided!"
    if !extract.thingyPath
        throw "fatal error: no default thingyPath was not available as fallback!"
    
    if !(typeof extract.name == "string")
        throw "Usage error: option name was provided in an unexpected way!"
    if !(typeof extract.thingyPath == "string")
        throw "Usage error: option thingyPath was provided in an unexpected way!"
    
#endregion

#region exposed functions
cliargumentsmodule.extractArguments = ->
    log "cliargumentsmodule.extractArguments"
    options = getOptions()
    meowed = meow(getHelpText(), getOptions())
    extract = extractMeowed(meowed)
    throwErrorOnUsageFail(extract)
    return extract

#endregion exposed functions

module.exports = cliargumentsmodule
