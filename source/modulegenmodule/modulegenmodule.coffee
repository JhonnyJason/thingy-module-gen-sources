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
import * as pathHandler from "./pathhandlermodule.js"

#endregion



##############################################################################
#region classes
class Task
    constructor: (@moduleName) -> return
    do: -> return

class CoffeeGenTask extends Task
    templatePath = pathModule.resolve( __dirname, "file-templates/coffee.M")
    do: ->
        log "do CoffeeGenTask for module " + @moduleName
        fileName = @moduleName + ".coffee"
        filePath = pathModule.resolve(pathHandler.modulePath,  fileName)
        # log "filePath: " + filePath

        template = await fs.readFile(templatePath, "utf-8")        
        fileContent = M.render(template, {moduleName: @moduleName})
        
        # log "\n - - - \nfileContent:\n" + fileContent
        await fs.writeFile(filePath, fileContent)

class PugGenTask extends Task
    templatePath = pathModule.resolve( __dirname, "file-templates/pug.M")
    do: ->
        log "do PugGenTask for module " + @moduleName
        pugname = getPugName(@moduleName)
        # log "pugname: " + pugname
        fileName = pugname + ".pug"
        filePath = pathModule.resolve(pathHandler.modulePath,  fileName)
        # log "filePath: " + filePath

        template = await fs.readFile(templatePath, "utf-8")
        fileContent = M.render(template, {moduleName: pugname})

        # log "\n - - - \nfileContent:\n" + fileContent
        await fs.writeFile(filePath, fileContent)
        
class StyleGenTask extends Task
    templatePath = pathModule.resolve( __dirname, "file-templates/styl.M")
    do: ->
        log "do StyleGenTask for module " + @moduleName
        fileName = "styles.styl"
        pugname = getPugName(@moduleName)
        # log "pugname: " + pugname
        filePath = pathModule.resolve(pathHandler.modulePath,  fileName)
        # log "filePath: " + filePath

        template = await fs.readFile(templatePath, "utf-8")        
        fileContent = M.render(template, {moduleName: pugname})

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
    dirPath = pathHandler.modulePath
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

