import std/strformat
import std/strutils
import std/sequtils
import std/json

import db_connector/db_sqlite

export db_sqlite.Row
export db_sqlite.exec

type Db* = DbConn


type ModelInterface = concept x
  x.tablename() is string


type HasId = concept x
  x.id is int64
  x.tablename() is string


type InsertQuery = ref object
  columns: string
  placeholders: string
  values: seq[JsonNode]


func dbConn*(): Db = open(":memory:", "", "", "")
func dbConn*(filename: string): Db = open(filename, "", "", "")


func gatVal(node: JsonNode): string =
  case node.kind
  of JString: node.getStr()
  of JInt: $node.getInt()
  else: ""


func build(pairs: seq[tuple[key: string, val: JsonNode]]): tuple[columns: string, values: seq[string]] =
  for i, pair in pairs:
    result.columns.add pair.key & (if i < pairs.len - 1: "," else: "")
    result.values.add pair.val.gatVal()

    
proc create*(db: Db, t: ModelInterface): int64 =
  let (columns, values) = toSeq((%* t).pairs).build()
  let placeholders = cycle("?", values.len).join(",")
  let query = &"""insert into {t.tablename} ({columns}) values ({placeholders});"""

  debugEcho query
  db.insertID(sql query, values)


func selectAll*(db: Db, table: string): seq[Row] =
  let query = sql(&"""select * from {table};""")
  db.getAllRows query


func first*(db: Db, t: HasId): Row =
  let query = &"""select * from {t.tablename} where id = ?;"""
  db.getRow(sql query, t.id)


func find*(db: Db, t: ModelInterface, where: seq[tuple[key: string, value: string]]): seq[Row] =
  let query = &"""select * from {t.tablename} where """
  db.getAllRow(sql query, t.id)


func find*(db: Db, t: ModelInterface): seq[Row] =
  let query = &"""select * from {t.tablename}"""
  db.getAllRow(sql query, t.id)


when isMainModule:
  import std/strutils
  import std/sequtils

  import db_connector/db_sqlite

  type User = ref object of RootObj
    name: string
    age: int

  type UserTable = ref object of User
    id: int64

  func tablename(self: User): string = "users"

  let db = open(":memory:", "", "", "")

  let ddl = @[
    """drop table if exists users;""",
    """create table users (id integer primary key autoincrement, name text, age integer) STRICT;""",
  ]

  for d in ddl:
    echo db.tryExec sql(d)

  for i in 0..2:
    let u = User(name: "hoge" & $i, age: 1)
    echo u.name, u.age
    discard db.create(u)
  
  let query = "select * from users;"
  let row = db.first(UserTable(id: 10))
  echo row