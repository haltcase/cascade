version       = "0.1.0"
author        = "citycide"
description   = "Method & assignment cascades for Nim, inspired by Smalltalk & Dart."
license       = "MIT"
skipDirs      = @["tests"]

requires "nim >= 0.17.1"

task test, "Run tests":
  exec "nim c -r " & "tests/tests.nim"
