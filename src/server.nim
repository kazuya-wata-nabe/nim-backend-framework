import std/asynchttpserver
import std/asyncdispatch
import std/strutils
import std/sugar

import ./utils
import src/lib/utils
import src/router
import ./handler
import src/db/conn

import src/domain/user/[model, usecase/list, persist/sqlite]
import src/controller/user/[fetch]
import src/controller/cart/[update]
import src/features/cart/[http_port, usecase]

type Controllers = ref object
  # user: UserController
  cart: proc(req: Request): Future[void]{.gcsafe.}


proc initRouter(c: Controllers, req: Request) {.async.} =
  # GROUP req, "/users":
  #   LIST:
  #     await c.user.fetchUsers(req)
  # await c.cart(req)
  if req.url.path == "/cart":
    await CartUpdateController.invoke(req)


  GROUP req, "/pets":
    LIST:
      await req.json(Http200, "pets")

  await req.text(Http404, $Http404)


proc main() {.async.} =
  var server = newAsyncHttpServer()
  let settings = newSettings()
  let db = dbConn("db.sqlite3")

  let controllers = Controllers(
    # user: db |> newUserRepository |> newListUsecase |> newUserController,
    cart: proc(req: Request): Future[void] =
      if req.url.path == "/cart" and req.reqMethod == HttpGet:
        result = req.json(Http200, "data")
  )

  let router = proc(req: Request){.async.} =
    initRouter(controllers, req)


    

  server.listen(Port settings.port)
  let port = server.getPort
  echo "test this with: curl localhost:" & $port.uint16 & "/"

  while true:
    if server.shouldAcceptRequest():
      await server.acceptRequest(router)
    else:
      await sleepAsync(500)

waitFor main()
