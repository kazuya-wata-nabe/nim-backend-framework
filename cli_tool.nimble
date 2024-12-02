# Package

version       = "0.1.0"
author        = "kazuya-wata-nabe"
description   = "A new awesome nimble package"
license       = "MIT"
srcDir        = "src"
bin           = @["main"]

# Dependencies

requires "nim >= 2.2.0"
requires "db_connector"



task format, "run format":
  exec "nimpretty  src/*"

import std/os
import std/strutils

task sweep, "remove binary file":
  for file in walkDirRec("src"):
    let (dir, name, ext) = splitFile(file)
    if ext == "":
      echo dir & "/" & name
      rmFile dir & "/" & name

task server, "start server":
  exec "nim c -r src/server.nim"

task db_init, "initialize database":
  exec "echo .open db.sqlite3 | sqlite3"


task db_migrate, "migrate":
  exec "echo date"