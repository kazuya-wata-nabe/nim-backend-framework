import std/strformat
import std/strutils
import std/sequtils
import std/json
import std/tables
import db_connector/db_sqlite

import src/domain/basemodel

export db_sqlite.Row
export db_sqlite.exec
export db_sqlite.DbConn

export tables


type InsertQuery = ref object
  columns: string
  placeholders: string
  values: seq[JsonNode]


func dbConn*(filename: string): DbConn = open(filename, "", "", "")


func gatVal(node: JsonNode): string =
  case node.kind
  of JString: node.getStr()
  of JInt: $node.getInt()
  else: ""

func toStructVal(node: JsonNode, val: JsonNode): JsonNode =
  case val.kind
  of JInt: newJInt(node.getStr().parseInt())
  else: node

func convert(node: JsonNode, typenames: seq[JsonNode]): JsonNode =
  result = node
  for i, key in toSeq(node.keys):
    result[key] = toStructVal(node[key], typenames[i])


func deserialize(jsonNode: JsonNode, typename: string): JsonNode =
  result = jsonNode
  for pair in jsonNode.pairs:
    result[pair.key] = pair.val


func build(t: ref object, skipId: bool = false): tuple[
    columns: string, values: seq[string]] =
  let pairs = toSeq(( %* t).pairs)
  for i, pair in pairs:
    if skipId and pair.key == "id":
      continue
    result.columns.add pair.key & (if i < pairs.len - 1: "," else: "")
    result.values.add pair.val.gatVal()

# TODO: to macro
func getNodeTypes(t: ref object): seq[JsonNode] =
  let pairs = toSeq(( %* t).pairs)
  for i, pair in pairs:
    result.add pair.val


proc create*(db: DbConn, t: WriteModel): int64 =
  let (columns, values) = t.build(skipId = true)
  let placeholders = cycle("?", values.len).join(",")
  let query = &"""insert into {t.tableName} ({columns}) values ({placeholders});"""
  try:
    result = db.insertID(sql query, values)
  except:
    debugEcho query
    debugEcho "err is: ", getCurrentExceptionMsg()


iterator selectAll*(db: DbConn, t: ReadModel): JsonNode =
  let (columns, values) = t.build()
  let typeNames = getNodeTypes(t)
  let query = &"""select {columns} from {t.tableName};"""
  let fields = columns.split(",")
  try:
    for row in db.getAllRows(sql query):
      let record = zip(fields, row).toTable()
      let jsonNode = convert(%record, typeNames)
      yield jsonNode
  except:
    debugEcho query
    debugEcho "err is: ", getCurrentExceptionMsg()



func first*(db: DbConn, t: ReadModel): Row =
  let query = &"""select * from {t.tableName} where id = ?;"""
  db.getRow(sql query, t.id)


func find*(db: DbConn, t: ReadModel, where: seq[tuple[key: string,
    value: string]]): seq[Row] =
  let query = &"""select * from {t.tableName} where = ?"""
  db.getAllRow(sql query, t.id)


func find*(db: DbConn, t: ReadModel): seq[Row] =
  let query = &"""select * from {t.tableName}"""
  db.getAllRow(sql query, t.id)


when not defined(release):
  import std/os

  iterator ddlList(): string =
    let files = toSeq(walkFiles(getCurrentDir() & "/src/db/migration/*.sql"))
    for file in files:
      let ddl = readFile(file).split(";").filterIt(not it.isEmptyOrWhitespace())
      for i, d in ddl:
        yield d & ";"


  proc execDDL(db: DbConn) =
    for ddl in ddlList():
      let success = db.tryExec(sql ddl)
      if not success:
        echo ddl & " is failure"

  template withOnMemoryDb*(db, op: untyped): untyped =
    var db = dbConn(":memory:")
    op

  template withDb*(filename: string, db, op: untyped): untyped =
    var db = dbConn(filename)
    op
    db.close()


when isMainModule:
  if paramCount() > 0 and paramStr(1) == "--migrate":
    withDb getCurrentDir() & "/db.sqlite3", db:
      execDDL(db)

  if paramCount() > 0 and paramStr(1) == "--seed":
    withDb getCurrentDir() & "/db.sqlite3", db:
      db.exec(sql """insert into users (name) values ("hoge");""")


