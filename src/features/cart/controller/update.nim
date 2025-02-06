import std/json

import src/shared/controller
import src/features/cart/usecase


type CartUpdateController* = ref object
  usecase: CartItemAddUsecase

func new*(_: type CartUpdateController): CartUpdateController = 
  CartUpdateController(usecase: CartItemAddUsecase())

template UPDATE*(self: CartUpdateController): untyped = 
  let jsonNode = parseJson("{}")
  let data = self.usecase.invoke(jsonNode)
  req.json(Http200, data)
