import macros

macro cascade* (obj: typed, body: untyped): auto =
  let statements =
    if body.kind == nnkDo: body[6]
    else: body
  statements.expectKind(nnkStmtList)

  let id = genSym(kind = nskVar)
  let assignment = newVarStmt(id, obj)
  result = newStmtList(assignment)
  for statement in statements:
    case statement.kind:
    of nnkAsgn:
      result.add(
        newAssignment(
          newDotExpr(id, statement[0]),
          statement[1]
        )
      )
    of nnkCall:
      result.add(
        newCall(
          newDotExpr(id, statement[0])
        )
      )
    else: discard

  result.add(id)
