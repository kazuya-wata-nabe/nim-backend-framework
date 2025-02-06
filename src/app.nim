import std/asynchttpserver

type 
  App = ref object
  Handler = proc(req: Request)


func get(self: App, handler: Handler): auto =
  discard
