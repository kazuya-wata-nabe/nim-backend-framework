import std/json
import std/macros

import src/handler
import src/features/cart/usecase


type CartUpdateController* = ref object  


macro build*[T: typedesc](_: T, usecase: CartItemAddUsecase): untyped = 
  let req = ident "req"
  quote do:
    proc GET*(_: T, `req`: Request): Future[void] = 
      let jsonNode = parseJson("{}")
      let data = `usecase`(jsonNode)
      `req`.json(Http200, "ok")


macro build*[T: typedesc](_: T, usecase: CartItemAddUsecaseWithQueryService): untyped = 
  let req = ident "req"
  quote do:
    proc GET*(_: T, `req`: Request): Future[void] = 
      let jsonNode = parseJson("{}")
      let data = `usecase`.invoke(jsonNode)
      `req`.json(Http200, "ok")