##############################################################################
#region debug
import {createLogFunctions} from "thingy-debug"
{log, olog} = createLogFunctions("cliargumentsmodule")

#endregion

################################################################################
import meow from 'meow'


################################################################################
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
        importMeta: import.meta,
        flags:
            name:
                type: "string"
                alias: "n"
            thingyPath:
                type: "string"
                alias: "p"
    }

################################################################################
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

################################################################################
export extractArguments = ->
    log "extractArguments"
    meowed = meow(getHelpText(), getOptions())
    extract = extractMeowed(meowed)
    throwErrorOnUsageFail(extract)
    return extract

