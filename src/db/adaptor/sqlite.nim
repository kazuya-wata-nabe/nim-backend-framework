import std/json
import std/macros
import std/times
import std/strutils
import db_connector/sqlite3

import src/lib/parser_macros


type Model* = ref object of RootObj
  id: int64
  created_at: times.DateTime
  updated_at: times.DateTime
  deleted_at: times.DateTime


func `%`(val: times.DateTime): JsonNode =
  let v = if val.isInitialized: $val else: ""
  newJString(v)


func convert(field: string, _: type string): JsonNode =
  newJString()

func convert(schema: string): JsonNode =
  discard
  # case schema
  # of "string":
  #   convert()
  # else:
  #   newJNull
  # """
  # CREATE TABLE `products` (
  #   `id` integer PRIMARY KEY AUTOINCREMENT,
  #   `created_at` datetime,
  #   `updated_at` datetime,
  #   `deleted_at` datetime,
  #   `code` text,
  #   `price` integer
  # );
  # """

func autoMigrate[T: object](self: type T): void =
  discard

func toKebabCase(str: string): string =
  result = $str[0].toLowerAscii()
  for c in str[1..^1]:
    debugEcho c
    let prefix = if c in UppercaseLetters: "-" else: ""
    result.add prefix & c.toLowerAscii()


func toTableName(str: string): string =
  let letter = toKebabCase(str)
  case str[^1]
  of 's':
    letter & "es"
  else:
    letter & "s"


func toColumnType(str: string): string =
  discard

macro generateORM(node: typedesc): untyped =
  let impl = getImpl(node)
  let typeName = findChildRec(impl, nnkSym)
  let recList = findChildRec(impl, nnkRecList)
  expectKind recList, nnkRecList

  let exp = typeName.repr.toTableName()
  let columns = ""

  quote do:
    echo `exp`


when isMainModule:

  type Todo = ref object of RootObj
    name: string
  generateORM(Todo)
  # for field in jsonNode.fields:
  #   echo  $filed
# StmtList
#   TypeSection
#     TypeDef
#       Ident "Todo"
#       Empty
#       ObjectTy
#         Empty
#         OfInherit
#           Ident "RootObj"
#         RecList
#           IdentDefs
#             Ident "name"
#             Ident "string"
#             Empty
