import src/handler

type CartUpdateController* = ref object
  


proc invoke*(self: CartUpdateController, req: Request): Future[void] = 
  req.json(Http200, "ok")
