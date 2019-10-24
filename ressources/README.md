# thingycreaty - commandline wizard to create a thingy (App, Website, Service, Machine)

# Why?
I have experienced some hassles when developing on projects and their build system simultaneously.

- Updates on the build system must be copied to all other projects. 
- Source code sharing also required manual copying. Especially when developing on the same code but in different projects.

The main problems for me were the context switches and setup-time for setting up the required git repositores.

Also there is a vision about an extensive gitOps-network for all the evolving programs in the IoT. Where this will come in handy.

# What?
Thingycreate - originally thought as projectcreate - is a small project setup helper for many possible projects which inherently require the same repository strucure, use git submodules and a shared build system, which also is being worked on simultanously.

It became a "thingy" instead "project" because the concept of a project is inherently flawed by it's definition.

It is defined as a temporary endeavor with a beginning and an end. The limits set for a project are quite important for it. So no reasonable software "thingy" can really be a "project" actually.
There is just no scope for surely acceptable limitations.

Instead of looking at a single software "thingy" as a project - thus alienating and effectivly cripple it by putting illusionary limitations on it - we should look at the whole software evolution as an ongoing organic process, where that "thingy" is only an essentially very connected part of the whole.

# How?
Requirements
------------
* [GitHub account](https://github.com/)
* [Git installed](https://git-scm.com/)
* [Node.js installed](https://nodejs.org/)
* [Perl installed](https://www.perl.org)

Installation
------------

Current git version
``` sh
$ npm install -g git+https://github.com/JhonnyJason/thingycreate.git
```
Npm Registry
``` sh
$ npm install -g thingycreate
```


Usage
-----

It is advisable (also necessary for current version) that you have your [ssh access-key for github](https://help.github.com/en/articles/connecting-to-github-with-ssh) usable in your shell. I personally add it using the [ssh-agent](https://www.ssh.com/ssh/agent) right before I start developing anyways.

``` sh
$ thingycreate <thingyType> <thingyName> <basePath>
```
All parameters are optional, but currently not interchangable.

That means, if you want to provide a `basePath`, you also need to provide both the `thingyType` and the `thingyName`.

Then the wizard will ask you for what he needs to know ;-)

Example
-----
``` sh
$ thingycreate website the-new-website /home/imthauser/thingies
  _     _       _                                                        _          
 | |_  | |__   (_)  _ __     __ _   _   _    ___   _ __    ___    __ _  | |_    ___ 
 | __| | '_ \  | | | '_ \   / _` | | | | |  / __| | '__|  / _ \  / _` | | __|  / _ \
 | |_  | | | | | | | | | | | (_| | | |_| | | (__  | |    |  __/ | (_| | | |_  |  __/
  \__| |_| |_| |_| |_| |_|  \__, |  \__, |  \___| |_|     \___|  \__,_|  \__|  \___|
                            |___/   |___/                                           
? Github username: JhonnyJason
? Github password: [hidden]
  ◡ Checking credentials...Credentials Check succeeded!
  ◞ Checking thingy name "the-new-website"... acceptable!
All relevant repositories for the-new-website may be created :-)
  ◟ Checking if https://github.com/JhonnyJason/root-template.git is reachable...Reachable!
? 'the-new-website' - repository...  How shall it be initialized? copy https://github.com/JhonnyJason/root-template.git
  ◝ Checking if https://github.com/JhonnyJason/toolset.git is reachable...Reachable!
? 'the-new-website-toolset' - repository...  How shall it be initialized? use https://github.com/JhonnyJason/toolset.git
  ◞ Checking if https://github.com/JhonnyJason/sample-source.git is reachable...Reachable!
? 'the-new-website-sources' - repository...  How shall it be initialized? copy https://github.com/JhonnyJason/sample-source.git
? 'the-new-website-testing' - repository...  How shall it be initialized? create new
  ◞ Creating all repositories...created!
  ◝ Initializing all repositories...initialized!
All done!


```
Current Functionality
---------------------

- parameter `thingyName`: the name of the base repository
- parameter `thingyType`: (Website, App, Service, Machine, CLI) - determines structure of thingy
- parameter `basePath`: the path where all repositories are created. Result on success will be one repository with it's submodules, all set up with their remote at `basePath`/`thingyName`. The `basePath` can be relative or absolute. If omitted then cwd will be the `basePath`.
- Github Login (Will ask for your username and password, also handles 2fa) - ! Use username not the email-address!
- Preemptivly checks if the necessary repositories or directories may be created in their respective locations.
- Toolset Usage: The most important part of a thingy is it's toolset. We can use any toolset as toolset. We should have the relevant peparationScripts ready (prepareThingyForWebsite.pl, prepareThingyForApp.pl, prepareThingyForService.pl, prepareThingyForMachine.pl, prepareThingyForCli.pl)
- Source Usage: The source-code of the particular thingy the other more important part for our thingy. Here we can choose to copy from any of our own boilercode sources we might have ready for a particular thingy. Or we might even directly use another source without copying.

To Note: The `thingies` Object in the `publicConfig.json` determines the structure of a thingy and the possible behaviours.
When creating your own thingy structures - that would be the the file to configure it.  

---

# The Guts of thingycreate
## Configuration
Only config needed is the `publicConfig.json`. It defines the name of the tool. Also defines all the thingies.

Here is an example of how a thingy is defined:
```javascript
"website": {
    "templateURL": "https://github.com/JhonnyJason/root-template.git",
    "defaultBehaviour": "copy",
    "negotiableBehaviours": ["create"],
    "name": "",
    "postfix": "",
    "repo": "",
    "submodules": [
        {
            "templateURL": "https://github.com/JhonnyJason/toolset.git",
            "defaultBehaviour": "use",
            "negotiableBehaviours": ["copy"],
            "name": "toolset",
            "repo": "",
            "postfix": "-toolset",
            "submodules": []
        },
        {
            "templateURL": "https://github.com/JhonnyJason/website-sample-sources.git",
            "defaultBehaviour": "copy",
            "negotiableBehaviours": ["create", "use"],
            "name": "sources",
            "repo": "",
            "postfix": "-sources",
            "submodules": []
        },
        {
            "templateURL": "",
            "defaultBehaviour": "create",
            "negotiableBehaviours": [],
            "name": "output",
            "repo": "",
            "postfix": "-deploy",
            "submodules": []
        },
        {
            "templateURL": "",
            "defaultBehaviour": "create",
            "negotiableBehaviours": ["use", "copy"],
            "name": "testing",
            "repo": "",
            "postfix": "-testing",
            "submodules": []

        }
    ]
}
```


## createprocessmodule
Responsible for the base level creation process, the code speaks for itself (hopefully^^):
```coffeescript
createprocessmodule.execute = (arg1, arg2, path) ->
        thingy.digestConfig(cfg.public.thingies)
        useArguments(arg1, arg2)
        await pathHandler.tryUse(path)
        await github.buildConnection()
        await thingy.doUserInquiry()
        thingy.createRepositoryTree()
        await repositoryTree.initializeRepositories()
        await thingy.prepare()
        return true
```

## pathhandlermodule
Responsible to check if the `basePath` exists and is not within a git Repository already. 
Also checks the creatability for the directory which should be createdf for the thingy.

It also provides the relevant paths for the repositoryTreeHandler to clone copy and generally initialize the repository tree.

Interface:
```coffeescript
pathhandlermodule.tryUse = (providedPath) -> #async

pathhandlermodule.checkCreatability = (directoryName) -> #async

pathhandlermodule.createInitializationBase = (name) -> #async

pathhandlermodule.cleanInitializationBase = () -> #async

pathhandlermodule.getBasePath = () ->

pathhandlermodule.getGitPaths = (name) ->

pathhandlermodule.getLicenseSourcePaths = () ->

pathhandlermodule.getLicenseDestinationPaths = (repoDir) ->

pathhandlermodule.setThingyPath = (path) ->

pathhandlermodule.getToolsetPath = ()  ->

pathhandlermodule.getPreparationScriptPath = (scriptFileName) ->
```

## githubhandlermodule
Responsible to speak to github. uses `@oktocit/rest` package. Exposes some useful functions:

Interface:
```coffeescript
githubhandlermodule.buildConnection = -> #async

githubhandlermodule.assertUserHasNotThatRepo = (repo) -> #async

githubhandlermodule.checkIfUserHasRepo= (repo) -> #async

githubhandlermodule.createRepository = (repo) -> #async

githubhandlermodule.deleteUserRepository = (repo) -> #async
```
## githubremotehandlermodule
Produces `githubRemoteObject` from url or given owner,repo pair. The `githubRemoteObject` is the representation of a remote, may be asked for specific url representation and checked for reachability.

Interface:
```coffeescript
githubremotehandlermodule.createOwnRemote = (repoName) ->

githubremotehandlermodule.createRemoteFromURL = (url) ->

githubremotehandlermodule.createRemote = (ownerOrURL, repoName) ->
```
The `githubRemoteObject`:
```coffeescript
class githubRemoteObject
    constructor: (@owner, @repoName) ->

    checkReachability: -> #async

    getOwner: -> @owner

    getRepo: -> @repoName

    getHTTPS: -> @httpsURL

    getSSH: -> @sshURL

    isReachable: ->
```

## repositorytreehandlermodule
Holds a tree-style representation of the repositories with their subrepositories.
Also handles the information about if they shall be created, copied or just used.

Finally has the capability to recursivly create and initialize all the thingy.

Interface:
```coffeescript
repositorytreehandlermodule.initializeRepositories = -> #async

repositorytreehandlermodule.createRootRepository = (rootNode) ->

repositorytreehandlermodule.getRootRepository = -> treeRoot

repositorytreehandlermodule.createRepositoryNode = (node) ->

repositorytreehandlermodule.printRepositoryTree = ->
```
The `RepositoryNode`
```coffeescript
class RepositoryNode
    constructor: (constructorObject) ->

    initialize: -> #async

    getRemote: -> @remote

    getRepo: -> @repo

    getName: -> @name

    addSubrepository: (node) ->

    printToConsole: (prefix) ->

    getReposToCreate: -> 
```

## thingymodule
Responsible for all thingy-relevant information. E.g. the specific structure of the thingy and the valid type. When creating your own thingy, this is probably the right place to start;-)

Finally has the capability to call the relevant preparation script in the toolset. Or Fails throwing an Error, the relevant preparation script is not present.

Interface:
```coffeescript
thingymodule.doUserInquiry = -> #async

thingymodule.prepare = -> #async

thingymodule.digestConfig = (thingies) ->

thingymodule.setType = (newType) ->

thingymodule.setName = (newName) ->

thingymodule.getType = -> type

thingymodule.getName = -> name

thingymodule.hasName = -> (typeof name == "string") or name 

thingymodule.getRepos = -> allRepos

thingymodule.createRepositoryTree = ->
```

## thingyinquirermodule
Manages the questions to ask the user. Specificly used by the thingy to retrieve the relevant info about how to build the repository tree.

Interface:
```coffeescript
thingyinquirermodule.inquireThingyType =  (allTypes) ->
 
thingyinquirermodule.inquireThingyName = ->

thingyinquirermodule.inquireRepositoryTreatment = (node) ->
```


# Further steps
This Wizard will be furtherly generalized and extended, mainly to fit my own needs.
Ideas of what could come next:

- machine thingy structure
- more convenient argument handling
- make more configurable from perspective of user?
- maybe? introduce second layer of `thingyType` (App - ios, android, Website - onepager, multipager) 
- clean out some code
- use various non-github remotes
- create repositories on not-github systems

All sorts of inputs are welcome, thanks!

---

# License

## The Unlicense JhonnyJason style

- Information has no ownership.
- Information only has memory to reside in and relations to be meaningful.
- Information cannot be stolen. Only shared or destroyed.

And you whish it has been shared before it is destroyed.

The one claiming copyright or intellectual property either is really evil or probably has some insecurity issues which makes him blind to the fact that he also just connected information which was free available to him.

The value is not in him who "created" the information the value is what is being done with the information.
So the restriction and friction of the informations' usage is exclusively reducing value overall.

The only preceived "value" gained due to restriction is actually very similar to the concept of blackmail (power gradient, control and dependency).

The real problems to solve are all in the "reward/credit" system and not the information distribution. Too much value is wasted because of not solving the right problem.

I can only contribute in that way - none of the information is "mine" everything I "learned" I actually also copied.
I only connect things to have something I feel is missing and share what I consider useful. So please use it without any second thought and please also share whatever could be useful for others. 

I also could give credits to all my sources - instead I use the freedom and moment of creativity which lives therein to declare my opinion on the situation. 

*Unity through Intelligence.*

We cannot subordinate us to the suboptimal dynamic we are spawned in, just because power is actually driving all things around us.
In the end a distributed network of intelligence where all information is transparently shared in the way that everyone has direct access to what he needs right now is more powerful than any brute power lever.

The same for our programs as for us.

It also is peaceful, helpful, friendly - decent. How it should be, because it's the most optimal solution for us human beings to learn, to connect to develop and evolve - not being excluded, let hanging and destroy.

If we really manage to build an real AI which is far superior to us it will unify with this network of intelligence.
We never have to fear superior intelligence, because it's just the better engine connecting information to be most understandable/usable for the other part of the intelligence network.

The only thing to fear is a disconnected unit without a sufficient network of intelligence on its own, filled with fear, hate or hunger while being very powerful. That unit needs to learn and connect to develop and evolve then.

We can always just give information and hints :-) The unit needs to learn by and connect itself.

Have a nice day! :D