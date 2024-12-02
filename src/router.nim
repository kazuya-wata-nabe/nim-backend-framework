import std/asynchttpserver
import std/asyncdispatch
import std/macros
import std/strutils
import std/re


func match(req: Request, path: string): bool =
  let ptn = "^" & path & "/[a-zA-Z0-9]+"
  match(req.url.path, re ptn)


func slice(value: string, pos: int): string =
  if value.len < pos:
    ""
  else:
    value[pos..<value.len]

# TODO: support nested group
macro GROUP*(req, prefix, body: untyped) =
  prefix.expectKind nnkStrLit
  let path = ident "path"
  quote do:
    block:
      template LIST(op: untyped): untyped =
        if req.reqMethod == HttpGet and req.url.path == `prefix`:
          op

      template CREATE(op: untyped): untyped =
        if req.reqMethod == HttpPost and req.url.path == `prefix`:
          op

      template READ(op: untyped): untyped =
        if req.reqMethod == HttpGet and req.match `prefix`:
          let id{.inject.} = req.url.path.slice(`prefix`.len)
          op

      template UPDATE(op: untyped): untyped =
        if req.reqMethod == HttpPut and req.match `prefix`:
          let id{.inject.} = req.url.path.slice(`prefix`.len)
          op

      template DELETE(op: untyped): untyped =
        if req.reqMethod == HttpDelete and req.match `prefix`:
          let id{.inject.} = req.url.path.slice(`prefix`.len)
          op

      if startsWith(`req`.url.path, `prefix`):
        `body`
