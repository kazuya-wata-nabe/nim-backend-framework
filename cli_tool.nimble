# Package

version       = "0.1.0"
author        = "kazuya-wata-nabe"
description   = "A new awesome nimble package"
license       = "MIT"
srcDir        = "src"
bin           = @["server"]

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


task db_migrate, "migrate":
  rmFile "db.sqlite3"
  exec "echo .open db.sqlite3 | sqlite3"
  exec """nim c -r src/db/conn --migrate"""
  exec """nim c -r src/db/conn --seed"""



task test_unit, "run testament":
  exec """testament p "tests/**/*.nim""""