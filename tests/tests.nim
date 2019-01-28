import unittest

import cascade

type
  Button = object
    text: string
    width: int
    color: string

  Foo = object
    first: int
    second: string
    third: float

  Bar = ref object
    alpha: int
    beta: string

  Sub = object
    foo: Foo

method btnEcho (btn: Button) {.base.} =
  discard "some method"

suite "cascade":
  test "equivalent to original `var` usage":
    let btn = cascade Button():
      text = "ok"
      width = 30
      color = "#13a89e"
      btnEcho()

    var res = Button()
    res.text = "ok"
    res.width = 30
    res.color = "#13a89e"
    res.btnEcho()

    check btn == res

  test "basic with":
    
    var foo = Foo(first: 1, second: "two", third: 3.0)
    
    with foo:
      doAssert first == 1
      doAssert second == "two"
      doAssert third == 3.0
    
  test "nested with":
    
    var foo = Foo(first: 1, second: "two", third: 3.0)
    var bar = Bar(alpha: 10, beta: "twenty")
    
    with foo:
      doAssert first == 1
      doAssert second == "two"
      with bar:
        doAssert third == 3.0
        doAssert alpha == 10
        doAssert beta == "twenty"
    
  test "with on sub-objects":
   
    var sub = Sub(foo: Foo(first: 1))

    with sub:
      doAssert foo.first == 1

  test "with in nested proc":
    
    var foo = Foo(first: 1, second: "two", third: 3.0)
    
    with foo:
      proc test() =
        doAssert first == 1
        doAssert second == "two"
        doAssert third == 3.0
      test()
  
