import std/asynchttpserver
import std/asyncdispatch

import src/shared/router

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

proc html(req: Request, status: HttpCode, content: string): Future[void] = 
  req.respond(status, STYLE & LAYOUT & content, HEADERS.newHttpHeaders())



proc router*(req: Request) {.async.} =
  if req.eq("/", HttpGet):
    await req.html(Http200, "<div>hoge</div>")

  await req.respond(Http404, $Http404)
