
startupmodule = {name: "startupmodule"}

#region node_modules
chalk       = require('chalk')
clear       = require('clear')
figlet      = require('figlet')
minimist    = require('minimist')
#endregion

#log Switch
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["startupmodule"]?  then console.log "[startupmodule]: " + arg
    return

#region internal variables
createProcess = null
config = null 
#endregion

##initialization function  -> is automatically being called!  ONLY RELY ON DOM AND VARIABLES!! NO PLUGINS NO OHTER INITIALIZATIONS!!
startupmodule.initialize = () ->
    log "startupmodule.initialize"
    createProcess = allModules.createprocessmodule
    config = allModules.configmodule

#region internal functions
printBanner = ->
    clear()
    console.log(
        chalk.green(
            figlet.textSync(config.public.name, { horizontalLayout: 'full' })
        )
    )

#endregion

#region exposed functions
startupmodule.cliStartup = ->
    log "startupmodule.cliStartup"
    printBanner()
    try
        args = minimist(process.argv.slice(2))
        # console.log(chalk.yellow("caught arguments are: " + args._))
        done = await createProcess.execute(args._[0], args._[1], args._[2])
        if done then console.log(chalk.green('All done!\n'));
    catch err
        console.log(chalk.red('Error!'));
        console.log(err)
        console.log("\n")

#endregion exposed functions

module.exports = startupmodule

