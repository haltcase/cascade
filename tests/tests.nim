import unittest

import cascade

type Button = object
  text: string
  width: int
  color: string

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
