import std/macros
import std/sequtils
import std/strutils
import std/strformat

import src/validation/rules

type
  PragmaDef = object
    name: string
    params: seq[string]

  Field = object
    name: string
    pragmas: seq[PragmaDef]

  ValidationError* = ref object
    name*: string
    rule*: string
    params*: seq[string]


func newPragmaDef(pragma: NimNode): PragmaDef{.compileTime.} =
  if pragma.kind == nnkSym:
    result = PragmaDef(name: pragma.repr)
  if pragma.kind == nnkCall:
    let name = pragma[0]
    let params = pragma[1..^1].mapIt(it.repr)
    result = PragmaDef(name: name.repr, params: params)


func newField(pragmaExpr: NimNode): Field{.compileTime.} =
  pragmaExpr.expectKind nnkPragmaExpr
  let name = pragmaExpr[0]
  let pragmas = toSeq(pragmaExpr[1].children)
  let pragmasDefs = pragmas.mapIt(newPragmaDef(it))
  Field(name: name.repr, pragmas: pragmasDefs)


func getPragmaExprs(node: NimNode): seq[NimNode]{.compileTime.} =
  let identDefs = toSeq(node.children)
  for identDef in identDefs:
    result.add identDef[0]


macro generateValidator(t: typedesc): untyped =
  let impl = getTypeInst(t)[1].getImpl()
  let typename = impl[0]
  let recList = impl[2][0][2]
  let pragmaExprs = getPragmaExprs(recList)
  let fields = pragmaExprs.mapIt(newField(it))

  var stmtList = newStmtList()
  for field in fields:
    for pragma in field.pragmas:
      let params = pragma.params.join(",")
      stmtList.add parseStmt &"""
        if not t.{field.name}.{pragma.name}({params}): 
          errors.add ValidationRule.{pragma.name}("{field.name}",{params})
      """
  let t = ident("t")
  let errors = ident("errors")
  quote do:
    func validate*(`t`: `typename`): seq[string] =
      var `errors` = newSeqOfCap[string](20)

      `stmtList`
      `errors`


when isMainModule:
  type User = ref object
    name{.required.}: string
    age {.required, lessThan(50).}: int

  generateValidator(User)

  doAssert User().validate() == @["name is required", "age is required"]
  doAssert User(age: 51).validate() == @["name is required", "age must be less than 50"]

## dumpTree:
##  type User = ref object
##    name{.required.}: string
##    age{.lessThan(50), between(1,2).}: string
##
## StmtList
##   TypeSection
##     TypeDef
##       Ident "User"
##       Empty
##       RefTy
##         ObjectTy
##           Empty
##           Empty
##           RecList
##             IdentDefs
##               PragmaExpr
##                 Ident "name"
##                 Pragma
##                   Ident "required"
##               Ident "string"
##               Empty
##             IdentDefs
##               PragmaExpr
##                 Ident "age"
##                 Pragma
##                   Call
##                     Ident "lessThan"
##                     IntLit 50
##                   Call
##                     Ident "between"
##                     IntLit 1
##                     IntLit 2
##               Ident "string"
##               Empty
