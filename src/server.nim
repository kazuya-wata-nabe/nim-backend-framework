import std/asynchttpserver
import std/asyncdispatch
import std/strutils

import src/db/conn
import src/shared/router

import src/features/cart/[usecase, controller/update]


type Settings = ref object
  port: uint


func newSettings*(params: seq[string] = @[]): Settings =
  result = Settings(port: 5000)

  for i, param in params:
    if param == "--port" and params.len >= i + 1:
      result.port = parseUInt params[i + 1]


func port*(self: Settings): uint16 =
  self.port.uint16




proc main() {.async.} =
  var server = newAsyncHttpServer()
  let settings = newSettings()
  let db = dbConn("db.sqlite3")

  let cartItemAddUsecase = CartItemAddUsecase.new(newQueryService())
  let cartUpdateController =  CartUpdateController.new(cartItemAddUsecase)


  let router = proc(req: Request){.async.} =
    if req.url.path == "/cart" and req.reqMethod == HttpPut:
      await cartUpdateController.UPDATE(req)

    await req.respond(Http404, $Http404)


  server.listen(Port settings.port)
  let port = server.getPort
  echo "test this with: curl localhost:" & $port.uint16 & "/"

  while true:
    if server.shouldAcceptRequest():
      await server.acceptRequest(router)
    else:
      await sleepAsync(500)

waitFor main()
