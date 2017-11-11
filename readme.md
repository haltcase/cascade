# cascade &middot; ![nimble](https://img.shields.io/badge/available%20on-nimble-yellow.svg?style=flat-square) ![license](https://img.shields.io/github/license/citycide/cascade.svg?style=flat-square)

> Method & assignment cascades for Nim, inspired by Smalltalk & Dart.

cascade is a macro for Nim that implements _method cascades_, a feature
originally from Smalltalk that's made its way into modern languages like
[Dart][dart] and [Kotlin][kotlin].

It allows you to avoid repeating an object's name for each method call
or assignment. A common case is something like a button:

```nim
# before
var res = Button()
res.text = "ok"
res.width = 30
res.color = "#13a89e"
res.btnEcho()
```

With cascade, you don't need to repeat yourself:

```nim
# after
let btn = cascade Button():
  text = "ok"
  width = 30
  color = "#13a89e"
  btnEcho()
```

Also notice you can avoid declaring a `var` if you don't need to modify
the target object after the fact, since it remains mutable within the
cascade block.

## installation & usage

Install using [Nimble][nimble]:

```shell
nimble install cascade
```

Then `import` and use:

```nim
import cascade

let x = cascade y:
  z = 10
  f()
```

## building

To build cascade from source you'll need to have [Nim][nim] installed,
and should also have [Nimble][nimble], Nim's package manager.

1. Clone the repo: `git clone https://github.com/citycide/cascade.git`
2. Move into the newly cloned directory: `cd cascade`
3. Make your changes: `cascade.nim`, `tests/tests.nim`
4. Run tests: `nimble test`

## contributing

You can check the [issues](https://github.com/citycide/cascade/issues) for
anything unresolved, search for a problem you're encountering, or open a new
one. Pull requests for improvements are also welcome.

## license

MIT © [Bo Lingen / citycide](https://github.com/citycide)

[dart]: https://www.dartlang.org/guides/language/language-tour#cascade-notation-
[kotlin]: http://beust.com/weblog/2015/10/30/exploring-the-kotlin-standard-library/
[nim]: https://github.com/nim-lang/nim
[nimble]: https://github.com/nim-lang/nimble
