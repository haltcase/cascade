import macros

# rewrite a tree of dot expressions to make the
# given `id` the topmost object in the chain
proc rewriteDotExpr (id, dotExpr: NimNode): NimNode =
  var lhs = dotExpr[0]
  var rhs = dotExpr[1]

  if lhs.kind != nnkDotExpr:
    return newDotExpr(newDotExpr(id, lhs), rhs)

  result = newDotExpr(id, rhs)
  var chain: seq[NimNode]

  while true:
    if lhs.kind == nnkDotExpr:
      rhs = lhs[1]
      lhs = lhs[0]
      chain.add rhs
    else:
      chain.add lhs
      break

  for i in countdown(chain.len - 1, 0):
    result[0] = newDotExpr(result[0], chain[i])

macro cascade* (obj: typed, body: untyped): untyped =
  let statements =
    if body.kind == nnkDo: body[6]
    else: body
  statements.expectKind(nnkStmtList)

  proc transform (id, statementList: NimNode, init = newStmtList()): NimNode =
    result = init
    for statement in statementList:
      case statement.kind
      of nnkIfStmt, nnkWhenStmt:
        # recurse into each branch of `if` or `when`

        for branch in statement:
          case branch.kind
          of nnkElifBranch:
            branch[1] = transform(id, branch[1])
          of nnkElse:
            branch[0] = transform(id, branch[0])
          else:
            discard

        result.add statement
      of nnkAsgn:
        var lhs = statement[0]
        if lhs.kind == nnkDotExpr:
          lhs = rewriteDotExpr(id, lhs)
        else:
          lhs = newDotExpr(id, lhs)

        result.add newAssignment(lhs, statement[1])
      of nnkCall, nnkCommand:
        var call: NimNode
        if statement[0].kind == nnkDotExpr:
          call = newCall(rewriteDotExpr(id, statement[0]))
        else:
          call = newCall(statement[0], id)

        for i in 1 ..< statement.len:
          call.add statement[i]

        result.add call
      else:
        result.add statement

  # create a `var` declaration with a unique generated identifier name
  let id = genSym(kind = nskVar)
  # assign the initial object to this new `var`
  let assignment = newVarStmt(id, obj)

  # kick off transformation on a new statement list
  # each `statement` in `statements` will be added to this
  # new statement list after being bound to the initial object
  result = transform(id, statements, newStmtList(assignment))

  # return the initial object
  result.add id
