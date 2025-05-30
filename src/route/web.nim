import std/asynchttpserver
import std/asyncdispatch

import src/dependency
import src/shared/router
import src/route/web/books

const HEADERS = [
  ("content-type", "text/html charset=utf8;")
]

const STYLE = """
<style>
ul, li, form { margin: 0 }
body { display: flex; gap: 8px; }
aside { width: 200px; overflow: hidden; }
</style>
"""

const LAYOUT = """
<aside>
  <ul>
    <li>
      <a href=/books > books </a>
    </li>
    <li>
      <a href=/books/create > books create </a>
    </li>
  </ul>
</aside>
"""

func layout(body: string): string =
  STYLE & LAYOUT & 
  "<div>" & body & "<div>"

proc html(req: Request, status: HttpCode, content: string): Future[void] = 
  req.respond(status, layout content, HEADERS.newHttpHeaders())

proc html(req: Request, content: string, status: HttpCode = Http200): Future[void] = 
  req.respond(status, layout content, HEADERS.newHttpHeaders())



proc router*(deps: Dependency, req: Request) {.async.} =
  if req.eq("/", HttpGet):
    await req.html("<div>hoge</div>")
  if req.eq("/books", HttpGet):
    await req.html(books.list deps.bookListController)

  await req.respond(Http404, $Http404)


proc router*(deps: Dependency): auto =
  proc(req: Request) {.async.} =
    await router(deps, req)