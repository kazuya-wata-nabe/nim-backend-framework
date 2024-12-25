import std/oids

let migration_history = "migration_histories"

func up() = discard
func down() = discard
func migrate() = discard
proc seed() = discard


iterator parseDDL(str: string): string =
  var line = ""
  for c in str:
    line.add c
    if c == ';':
      yield line
      line = ""


when isMainModule:
  import db_connector/db_sqlite

  let db = open(":memory:", "", "", "")
  let ddl = """
    drop table if exists users;
    create table users (id integer primary key autoincrement, name text);
    insert into users (name) values ("hoge");
  """

  for d in parseDDL(ddl):
    echo db.tryExec sql(d)

  let query = "select * from users;"
  for row in db.fastRows(sql query):
    echo row
