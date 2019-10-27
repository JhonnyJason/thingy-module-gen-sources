modulegenmodule = {name: "modulegenmodule"}

#region node_modules
fs = require "fs-extra"
mustache = require "mustache"
pathModule = require "path"
#endregion

#log Switch
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["modulegenmodule"]?  then console.log "[modulegenmodule]: " + arg
    return

#region internal variables
pathHandler = null
#endregion

##initialization function  -> is automatically being called!  ONLY RELY ON DOM AND VARIABLES!! NO PLUGINS NO OHTER INITIALIZATIONS!!
modulegenmodule.initialize = () ->
    log "modulegenmodule.initialize"
    pathHandler = allModules.pathhandlermodule
    return

#region classes
class Task
    constructor: (@moduleName) -> return
    do: -> return

class CoffeeGenTask extends Task
    templatePath = pathModule.resolve( __dirname, "file-templates/template.coffee")
    do: ->
        log "do CoffeeGenTask for module " + @moduleName
        fileName = @moduleName + ".coffee"
        filePath = pathModule.resolve(pathHandler.modulePath,  fileName)
        # log "filePath: " + filePath

        template = await fs.readFile(templatePath, "utf-8")        
        fileContent = mustache.render(template, {moduleName: @moduleName})
        
        # log "\n - - - \nfileContent:\n" + fileContent
        await fs.writeFile(filePath, fileContent)

class PugGenTask extends Task
    templatePath = pathModule.resolve( __dirname, "file-templates/template.pug")
    do: ->
        log "do PugGenTask for module " + @moduleName
        pugname = getPugName(@moduleName)
        # log "pugname: " + pugname
        fileName = pugname + ".pug"
        filePath = pathModule.resolve(pathHandler.modulePath,  fileName)
        # log "filePath: " + filePath

        template = await fs.readFile(templatePath, "utf-8")
        fileContent = mustache.render(template, {moduleName: pugname})

        # log "\n - - - \nfileContent:\n" + fileContent
        await fs.writeFile(filePath, fileContent)
        
class StyleGenTask extends Task
    templatePath = pathModule.resolve( __dirname, "file-templates/template.styl")
    do: ->
        log "do StyleGenTask for module " + @moduleName
        fileName = "styles.styl"
        pugname = getPugName(@moduleName)
        # log "pugname: " + pugname
        filePath = pathModule.resolve(pathHandler.modulePath,  fileName)
        # log "filePath: " + filePath

        template = await fs.readFile(templatePath, "utf-8")        
        fileContent = mustache.render(template, {moduleName: pugname})

        # log "\n - - - \nfileContent:\n" + fileContent
        await fs.writeFile(filePath, fileContent)

#endregion

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

#region exposed functions
modulegenmodule.generate = (files, name) ->
    log "modulegenmodule.generate"
    tasks = generateTasks(files, name)

    await generateModuleDirectory()    
    promises = (task.do() for task in tasks)
    await Promise.all(promises)
    
#endregion

module.exports = modulegenmodule