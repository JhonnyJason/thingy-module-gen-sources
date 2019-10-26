userinquirymodule = {name: "userinquirymodule"}

#region node_modules
inquirer = require("inquirer")
#endregion


#log Switch
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["userinquirymodule"]?  then console.log "[userinquirymodule]: " + arg
    return

#region internal variables
#endregion

#region exposed variables
#endregion


##initialization function  -> is automatically being called!  ONLY RELY ON DOM AND VARIABLES!! NO PLUGINS NO OHTER INITIALIZATIONS!!
userinquirymodule.initialize = () ->
    log "userinquirymodule.initialize"
    return

#region internal functions
generateFileOptions = () ->
    options = [
        {
            name: ".coffee"
            checked: true

        }
        {
            name: ".pug"
        }
        {
            name: "styles.styl"
        }
    ]    
    return options

createQuestion = (options) -> 
    return [
        {
            name: "filesToGenerate",
            type: "checkbox",
            message: "Which file do you need for this module?",
            choices: options
        }
    ]
#endregion

#region exposed functions
userinquirymodule.doInquiry =  ->
    options = generateFileOptions()
    question = createQuestion(options)
    answer = await inquirer.prompt(question)
    return answer.filesToGenerate
#endregion

module.exports = userinquirymodule