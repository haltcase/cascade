version       = "1.0.0"
author        = "citycide"
description   = "Method & assignment cascades for Nim, inspired by Smalltalk & Dart."
license       = "MIT"
skipDirs      = @["tests"]

requires "nim >= 1.0.0"

task test, "Run tests":
  exec "nim c -r " & "tests/tests.nim"
