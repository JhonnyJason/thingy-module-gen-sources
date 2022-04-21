# thingy-module-gen

# Background
The process of copying and refactoring an existing module is too tedious. 
Usually this tool is used from a a thingy toolset.
While for more sophisticated usage the tool [thingymodulecreate](https://www.npmjs.com/package/thingymodulecreate) will be used. 

The advantage of this tool is that it just instantly creates the directory and the files for the module in the most basic form.

# Usage
Installation
------------

Current git version
``` sh
$ npm install git+https://github.com/JhonnyJason/thingy-module-gen-output.git
```

Npm Registry
``` sh
$ npm install thingy-module-gen
```

CLI
-----

``` sh
$ thingy-module-gen <moduleName> <thingyPath>
```

The `thingyPath` is optional and will be current working directory when being omitted.

The generation will fail when we are not in a thingy root. That means that we should have a `sources/source` directory where we can add the new module.

The generation will also fail when we already have a directory with the same module name in `sources/source`.

The tool will ask the basic files to be generated for the new module.

Usually I go for a specific nameming. That is all modules are usually names like `newcomponentmodule`.
That means that usually the coffee file is `newcomponentmodule.coffee` then the pug file is `newcomponent.put` and the style file will always be just `styles.styl`.

Example
-----
``` sh
$ thingy-module-gen newcomponentmodule
 Module newcomponentmodule may be created!
? Which file do you need for this module? 
 ◉ .coffee
❯◯ .pug
 ◯ styles.styl

```

# Further steps
This tool will be adjusted to prepare a module to all its behaviours.

- ...

All sorts of inputs are welcome, thanks!

---

# License
[Unlicense JhonnyJason style](https://hackmd.io/nCpLO3gxRlSmKVG3Zxy2hA?view)
