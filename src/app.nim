import std/asynchttpserver
import std/asyncdispatch

type App = ref object
  server: AsyncHttpServer

func newApp*(): App =
  App(server: newAsyncHttpServer())

proc run*(self: App): Future[void]{.async.} =
  proc cb(req: Request){.async.} =
    await req.respond(Http200, "ok")

  while true:
    if self.server.shouldAcceptRequest():
      await self.server.acceptRequest(cb)
    else:
      await sleepAsync(500)
