##############################################################################
#region debug
import {createLogFunctions} from "thingy-debug"
{log, olog} = createLogFunctions("userinquirymodule")

#endregion

##############################################################################
import inquirer from "inquirer"

##############################################################################
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

##############################################################################
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

##############################################################################
export doInquiry =  ->
    options = generateFileOptions()
    question = createQuestion(options)
    answer = await inquirer.prompt(question)
    return answer.filesToGenerate
