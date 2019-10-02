import unittest

import cascade

type
  Qux = object
    ns: seq[int]

  Baz = object
    qux: Qux

  Bar = object
    n: int
    baz: Baz

  Foo = object
    str: string
    num: int
    list: seq[string]
    bar: Bar

  Button = object
    text: string
    width: int
    color: string

method enable (btn: Button) {.base.} =
  discard "some method"

proc setStr (foo: var Foo, val: string, suffix: string) =
  foo.str = "hello " & val & suffix

template blk (foo: Foo, body: untyped) =
  body

suite "cascade":
  test "basic field assignment":
    let foo = cascade Foo():
      str = "hello"
      num = 10

    check foo == Foo(str: "hello", num: 10)

  test "calling procs on fields":
    let foo = cascade Foo():
      list.add "one"
      list.add "two"

    check foo == Foo(list: @["one", "two"])

  test "calling procs on fields using named parameters":
    let foo = cascade Foo():
      setStr(suffix = "!", val = "world")

    check foo == Foo(str: "hello world!")

  test "nested field assignment":
    let foo = cascade Foo():
      bar.n = 100

    check foo == Foo(bar: Bar(n: 100))

  test "nested cascades":
    let foo = cascade Foo():
      bar = cascade Bar():
        n = 6
        baz = cascade Baz():
          qux = cascade Qux():
            ns = @[1, 2, 3, 4]

    let expected = Foo(
      bar: Bar(
        n: 6,
        baz: Baz(
          qux: Qux(
            ns: @[1, 2, 3, 4]
          )
        )
      )
    )

    check foo == expected

  test "deeply nested proc calls":
    let foo = cascade Foo():
      bar.baz.qux.ns.add 1

    let expected = Foo(
      bar: Bar(
        baz: Baz(
          qux: Qux(
            ns: @[1]
          )
        )
      )
    )

    check foo == expected

  test "bodies passed to calls are not modified":
    var condition = false
    let foo = cascade Foo():
      blk:
        condition = true

    check condition

  test "handles `if` conditionals":
    let foo = cascade Foo():
      if true:
        str = "yes"
      else:
        str = "no"

    check foo == Foo(str: "yes")

  test "recursively handles `if` conditionals":
    let foo = cascade Foo():
      if true:
        if false:
          str = "yes"
        else:
          str = "yes, but no"
      else:
        str = "no"

    check foo == Foo(str: "yes, but no")

  test "handles `when` conditionals":
    let foo = cascade Foo():
      when true:
        str = "yes"
      else:
        str = "no"

    check foo == Foo(str: "yes")

  test "recursively handles `when` conditionals":
    let foo = cascade Foo():
      when true:
        when false:
          str = "yes"
        else:
          str = "yes, but no"
      else:
        str = "no"

    check foo == Foo(str: "yes, but no")

  test "GUI button example":
    let btn = cascade Button():
      text = "ok"
      width = 30
      color = "#13a89e"
      enable()

    var res = Button()
    res.text = "ok"
    res.width = 30
    res.color = "#13a89e"
    res.enable()

    check btn == res
