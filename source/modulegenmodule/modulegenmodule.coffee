##############################################################################
#region debug
import {createLogFunctions} from "thingy-debug"
{log, olog} = createLogFunctions("modulegenmodule")

#endregion


##############################################################################
#region imports
import fs from "fs-extra"
import M from "mustache"
import pathModule from "path"

##############################################################################
import * as ph from "./pathhandlermodule.js"

#endregion



##############################################################################
#region classes
class Task
    constructor: (@moduleName) -> return
    do: -> return

class CoffeeGenTask extends Task
    template: """
        ############################################################
        #region debug
        import { createLogFunctions } from "thingy-debug"
        {log, olog} = createLogFunctions("{{moduleName}}")
        #endregion

        ############################################################
        export initialize = ->
            log "initialize"
            #Implement or Remove :-)
            return
        """
    do: ->
        log "do CoffeeGenTask for module " + @moduleName
        fileName = @moduleName + ".coffee"
        filePath = pathModule.resolve(ph.getModulePath(),  fileName)
        # log "filePath: " + filePath

        fileContent = M.render(@template, {moduleName: @moduleName})
        
        # log "\n - - - \nfileContent:\n" + fileContent
        await fs.writeFile(filePath, fileContent)

class PugGenTask extends Task
    template: """
        //- {{moduleName}} structure
        \#{{moduleName}}
        """
    do: ->
        log "do PugGenTask for module " + @moduleName
        pugname = getPugName(@moduleName)
        # log "pugname: " + pugname
        fileName = pugname + ".pug"
        filePath = pathModule.resolve(ph.getModulePath(),  fileName)
        # log "filePath: " + filePath

        fileContent = M.render(@template, {moduleName: pugname})

        # log "\n - - - \nfileContent:\n" + fileContent
        await fs.writeFile(filePath, fileContent)
        
class StyleGenTask extends Task
    template: """
        // {{moduleName}} styles
        \#{{moduleName}}
            width 100%
            min-height 20px
            background-color rgba(0, 0, 0, 0.2)
        """
    do: ->
        log "do StyleGenTask for module " + @moduleName
        fileName = "styles.styl"
        pugname = getPugName(@moduleName)
        # log "pugname: " + pugname
        filePath = pathModule.resolve(ph.getModulePath(),  fileName)
        # log "filePath: " + filePath

        fileContent = M.render(@template, {moduleName: pugname})

        # log "\n - - - \nfileContent:\n" + fileContent
        await fs.writeFile(filePath, fileContent)
    
#endregion

##############################################################################
#region internal functions
getPugName = (name) ->
    log "getPugName"
    index = name.lastIndexOf("module")
    dif = name.length - index
    if dif == 6 then return name.substring(0,index)
    return name

generateModuleDirectory = ->
    log "generateModuleDirectory"
    dirPath = ph.getModulePath()
    result = await fs.mkdirs(dirPath)
    log result
    return

generateTasks = (files, name) -> 
    log "generateTasks"
    tasks = []
    for file in files
        switch file
            when ".coffee" then tasks.push(new CoffeeGenTask(name))
            when ".pug" then tasks.push(new PugGenTask(name))
            when "styles.styl" then tasks.push(new StyleGenTask(name))
            else throw "unknown option to generate Task for: " + file
    return tasks

#endregion

##############################################################################
export generate = (files, name) ->
    log "generate"
    tasks = generateTasks(files, name)

    await generateModuleDirectory()    
    promises = (task.do() for task in tasks)
    await Promise.all(promises)
    return

