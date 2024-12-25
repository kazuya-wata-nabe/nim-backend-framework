import std/json
import std/os
import std/strutils

import src/domain/basemodel

proc getPath(tableName: string): string = getCurrentDir() & "/" & tableName & ".json"


proc readJson*(t: ReadModel): JsonNode =
  let path = getPath(t.tableName)
  let f = readFile(path)
  parseJson f


proc writeJson*(t: WriteModel) =
  let path = getPath(t.tableName)
  let mode = if fileExists(path): fmReadWriteExisting else: fmReadWrite
  let f = open(path, mode)
  defer: f.close()

  let jsonNode = %* t
  if f.endOfFile():
    jsonNode{"id"} = newJInt(1)
    let a = newJArray()
    a.add(jsonNode)
    f.write(a.pretty())
  else:
    var id = 1
    while not f.endOfFile():
      let line = f.readLine()
      # FIXME: minifyされたjsonの場合は正しいidを採番できない
      if line.contains("},") or line.contains(",{") or line.endsWith("}"):
        id.inc()
    let pos = f.getFilePos() - 2
    f.setFilePos(pos)
    jsonNode{"id"} = newJInt(id)
    f.write("," & jsonNode.pretty() & "\n]")
