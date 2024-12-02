import std/asynchttpserver
import std/asyncdispatch
import std/json

proc text*(self: Request, httpStatus: HttpCode, content: string): Future[void] =
  let headers = newHttpHeaders([("Content-type", "text/plain; charset=utf-8")])
  self.respond(httpStatus, content, headers)


proc json*(self: Request, httpStatus: HttpCode, content: ref object): Future[void] =
  let headers = newHttpHeaders([("Content-Type", "application/json")])
  let c = % content
  self.respond(httpStatus, $c, headers)

proc json*(self: Request, httpStatus: HttpCode, content: seq[
    ref object]): Future[void] =
  let headers = newHttpHeaders([("Content-Type", "application/json")])
  let c = % content
  self.respond(httpStatus, $c, headers)

proc json*(self: Request, httpStatus: HttpCode, content: string): Future[void] =
  let headers = newHttpHeaders([("Content-Type", "application/json")])
  self.respond(httpStatus, content, headers)

proc json*(self: Request, httpStatus: int, content: string): Future[void] =
  let headers = newHttpHeaders([("Content-Type", "application/json")])
  self.respond(HttpCode(httpStatus), content, headers)

proc json*(self: Request, httpStatus: int, content: JsonNode): Future[void] =
  let headers = newHttpHeaders([("Content-Type", "application/json")])
  self.respond(HttpCode(httpStatus), $content, headers)
