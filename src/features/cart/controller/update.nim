import std/json

import src/shared/controller
import src/features/cart/usecase


type CartUpdateController* = ref object
  usecase: CartItemAddUsecase

func new*(_: type CartUpdateController): CartUpdateController = 
  CartUpdateController(usecase: CartItemAddUsecase())

func new*(_: type CartUpdateController, usecase: CartItemAddUsecase): CartUpdateController = 
  CartUpdateController(usecase: usecase)

proc UPDATE*(self: CartUpdateController, req: Request): Future[void] = 
  let jsonNode = parseJson("{}")
  self.usecase.invoke(jsonNode)
  req.respond(Http200, "ok")
