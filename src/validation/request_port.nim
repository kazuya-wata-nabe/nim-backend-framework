import std/json
import std/sequtils
import std/macros

import std/strformat
import src/lib/parser_macros


func getFieldName(node: NimNode): NimNode =
  let firstChild = node[0]
  if firstChild.kind == nnkIdent:
    result = firstChild
  elif firstChild.kind == nnkPostfix:
    result = firstChild[1]


func getNameNode(node: NimNode): NimNode =
  var n = if node.kind == nnkPragmaExpr: node[0] else: node
  if n.kind == nnkPostfix:
    result = n[1]
  if n.kind == nnkIdent:
    result = n

func getVal(jsonNode: JsonNode, _: type string): string = jsonNode.getStr()
func getVal(jsonNode: JsonNode, _: type int): int = jsonNode.getInt()


macro generateUnMarshal*(t: typedesc): untyped =
  let impl = getImpl(t)
  let recList = findChildRec(impl, nnkRecList)
  let identDefs = toSeq(recList.children)
  let names = identDefs.mapIt(getNameNode(it[0]).repr)
  let types = identDefs.mapIt(it[1].repr)

  var stmtList = newStmtList()
  for (key, val) in zip(names, types):
    stmtList.add parseStmt &"""
    if jsonNode.hasKey("{key}"):
      result.{key} = jsonNode["{key}"].getVal({val})
    """

  let jsonNode = ident("jsonNode")

  quote do:
    func unmarshal(`jsonNode`: JsonNode, _: type `t`): `t` =
      result = `t`()
      `stmtList`
