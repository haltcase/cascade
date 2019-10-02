# cascade &middot; [![nimble](https://flat.badgen.net/badge/available%20on/nimble/yellow)](https://nimble.directory/pkg/cascade) ![license](https://flat.badgen.net/github/license/citycide/cascade)

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
res.enable()
```

With cascade, you don't need to repeat yourself:

```nim
# after
let btn = cascade Button():
  text = "ok"
  width = 30
  color = "#13a89e"
  enable()
```

Also notice you can avoid declaring a `var` if you don't need to modify
the target object after the fact &mdash; the object is mutable within the
cascade block but becomes a `let` binding outside of that block.

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

## supported constructs

* field assignment

  ```nim
  let foo = cascade Foo():
    bar = 100

  # ↑ equivalent ↓

  var foo = Foo()
  foo.bar = 100
  ```

* nested field assignment

  ```nim
  let foo = cascade Foo():
    bar.baz.qux = "awesome"

  # ↑ equivalent ↓

  var foo = Foo()
  foo.bar.baz.qux = "awesome"
  ```

* proc/template/method calls

  ```nim
  let foo = cascade Foo():
    fn("hello", "world")

  # ↑ equivalent ↓

  var foo = Foo()
  foo.fn("hello", "world")
  ```

* nested calls on fields

  ```nim
  let foo = cascade Foo():
    bar.baz.seqOfStrings.add "more awesome"

  # ↑ equivalent ↓

  var foo = Foo()
  foo.bar.baz.seqOfStrings.add "more awesome"
  ```

* `if` and `when` conditionals

  ```nim
  let foo = cascade Foo():
    if someCondition: bar.baz = 2

  # ↑ equivalent ↓

  var foo = Foo()
  if someCondition: foo.bar.baz = 2
  ```

* `cascade`s can be nested within each other

  ```nim
  let foo = cascade Foo():
    bar = cascade Bar():
      baz = cascade Baz():
        str = "we're down here now!"

  # ↑ equivalent ↓

  var foo = Foo()
  foo.bar = Bar()
  foo.bar.baz = Baz(str: "we're down here now!")
  ```

> Is something missing? Check the open [issues][issues] first or open a new
one. Pull requests are appreciated!

## building

To build cascade from source you'll need to have [Nim][nim] installed,
and should also have [Nimble][nimble], Nim's package manager.

1. Clone the repo: `git clone https://github.com/citycide/cascade.git`
2. Move into the newly cloned directory: `cd cascade`
3. Make your changes: `cascade.nim`, `tests/tests.nim`
4. Run tests: `nimble test`

## contributing

You can check the [issues][issues] for anything unresolved, search for a
problem you're encountering, or open a new one. Pull requests for improvements
are also welcome.

## license

MIT © [Bo Lingen / citycide](https://github.com/citycide)

[dart]: https://www.dartlang.org/guides/language/language-tour#cascade-notation-
[kotlin]: http://beust.com/weblog/2015/10/30/exploring-the-kotlin-standard-library/
[nim]: https://github.com/nim-lang/nim
[nimble]: https://github.com/nim-lang/nimble
[issues]: https://github.com/citycide/cascade/issues
