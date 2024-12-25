import std/macros
import std/sequtils


type
  PragmaDef = object
    name: string
    params: seq[string]

  Field = object
    name: string
    `type`: string
    pragmas: seq[PragmaDef]


func findChildRec(node: seq[NimNode], kind: NimNodeKind): NimNode =
  for n in node:
    result = n.findChild(it.kind == kind)
    if not result.isNil:
      return
    if result.isNil and n.len > 0:
      let children =  toSeq(n.children)
      return findChildRec(children, kind)
  
func findChildRec*(node: NimNode, kind: NimNodeKind): NimNode =
  findChildRec(@[node], kind)

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

