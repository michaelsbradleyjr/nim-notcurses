import std/[macros, sequtils, strutils]

macro coverageWrapper*(procedure: untyped, header: static string): untyped =
  # debugEcho treeRepr procedure
  result = newStmtList()
  let wrapper = procedure.copy
  procedure[0] = ident "wrapped_" & $wrapper.name
  procedure.addPragma ident "cdecl"
  procedure.addPragma newColonExpr(ident "header", newStrLitNode header)
  procedure.addPragma newColonExpr(ident "importc", newStrLitNode $wrapper.name)
  result.add procedure
  wrapper.addPragma ident "cdecl"
  var args: seq[NimNode]
  for node in procedure.params:
    if node.kind == nnkIdentDefs:
      for id in ($toStrLit(node)).split(":")[0].split(", ").mapIt(ident it):
        args.add id
  wrapper.body= newCall(procedure.name, args)
  result.add wrapper
  # debugEcho toStrLit result
