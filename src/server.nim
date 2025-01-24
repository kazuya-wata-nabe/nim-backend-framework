import std/asynchttpserver
import std/asyncdispatch
import std/json
import std/strutils
import std/os
import db_connector/db_sqlite

import ./utils
import ./controller
import src/router
import src/route/[user]
import ./handler
import src/db/db

proc initRouter(db: DbConn, req: Request) {.async.} =
  userRoute(req)

  GROUP req, "/pets":
    LIST:
      await req.json(Http200, "pets")

  if req.url.path == "/db":
    let rows = db.getRow(sql "select * from users;")
    echo $rows
    await req.json(Http200, "ok")

  await req.text(Http404, $Http404)


proc main() {.async.} =
  var server = newAsyncHttpServer()
  let settings = newSettings()
  let db = dbConn("db.sqlite3")
  let router = proc(req: Request){.async.} = initRouter(db, req)

  server.listen(Port settings.port)
  let port = server.getPort
  echo "test this with: curl localhost:" & $port.uint16 & "/"

  while true:
    if server.shouldAcceptRequest():
      await server.acceptRequest(router)
    else:
      # too many concurrent connections, `maxFDs` exceeded
      # wait 500ms for FDs to be closed
      await sleepAsync(500)

waitFor main()
