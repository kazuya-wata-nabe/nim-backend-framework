import std/asynchttpserver
import std/asyncdispatch
import std/json
import std/strutils

import ./utils
import ./controller
import src/router
import src/route/[user]
import ./handler

proc initRouter(req: Request) {.async.} =
  userRoute(req)

  GROUP req, "/pets":
    LIST:
      await req.json(Http200, "pets")

  await req.text(Http404, $Http404)

proc main() {.async.} =
  var server = newAsyncHttpServer()
  let settings = newSettings()

  server.listen(Port settings.port)
  let port = server.getPort
  echo "test this with: curl localhost:" & $port.uint16 & "/"

  while true:
    if server.shouldAcceptRequest():
      await server.acceptRequest(initRouter)
    else:
      # too many concurrent connections, `maxFDs` exceeded
      # wait 500ms for FDs to be closed
      await sleepAsync(500)

waitFor main()
