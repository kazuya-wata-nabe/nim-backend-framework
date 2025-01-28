import std/json
import std/macros

import src/handler
import src/features/cart/usecase


type CartUpdateController* = ref object  


macro build*(_: type CartUpdateController, usecase: CartItemAddUsecase): untyped = 
  let req = ident "req"
  quote do:
    proc invoke*(_: type CartUpdateController, `req`: Request): Future[void] = 
      let jsonNode = parseJson("{}")
      let data = `usecase`(jsonNode)
      `req`.json(Http200, "ok")