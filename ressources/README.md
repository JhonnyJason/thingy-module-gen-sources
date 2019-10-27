# thingy-module-gen - commandline wizard to easify the generation of a thingy module

# Why?
The process of copying and refactoring an existing module is too tedious. Also we can add further more complex functionality here later - module being git submodule and more.

Usually this tool is used from a a thingy toolset.

# How?
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


Usage
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

- module being it's own git submodule for code sharing
- introduce possibility to package module as node_module (add module as thingy-module when we continue to develop on it - add module as node_module when only using the module)
- ...

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