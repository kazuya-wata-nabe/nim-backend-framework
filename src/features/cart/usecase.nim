import std/json

import src/validation/request_port
import ./model

type 
  QueryService = ref object
  CartItemAddUsecase* = ref object
    queryService: QueryService
  ShoppingCartOutDto = JsonNode

generateUnMarshal(ShoppingCartItem)


proc invoke*(self: CartItemAddUsecase, jsonNode: JsonNode): ShoppingCartOutDto =
  let cart = newShoppingCart()
  let item = unmarshal(jsonNode, ShoppingCartItem)
  %* cart.add(item)
