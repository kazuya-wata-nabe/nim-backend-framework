import std/asynchttpserver
import std/asyncdispatch
import std/json
import std/strutils
import std/os
import db_connector/db_sqlite

import ./utils
import src/lib/utils
import ./controller
import src/router
import src/route/[user]
import ./handler
import src/db/conn

import src/domain/user/[model, repository, persist/sqlite]
import src/domain/user/usecase/[list]




type UserController = ref object 
  list: ListUsecase
  # create: ListUser

type Controllers = ref object
  user: UserController


proc initRouter(c: Controllers, req: Request) {.async.} =
  if req.url.path == "/users" and req.reqMethod == HttpGet:
    let data = c.user.list.invoke(req.body)
    await req.json(Http200, "data")


  GROUP req, "/pets":
    LIST:
      await req.json(Http200, "pets")

  await req.text(Http404, $Http404)


func newUserController(list: ListUsecase): UserController =
  UserController(list: list)


proc main() {.async.} =
  var server = newAsyncHttpServer()
  let settings = newSettings()
  let db = dbConn("db.sqlite3")

  let controllers = Controllers(
    user: db |> newUserRepository |> newListUsecase |> newUserController
  )
  
  let router = proc(req: Request){.async.} = initRouter(controllers, req)

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
