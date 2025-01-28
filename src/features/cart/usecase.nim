import ./model
import std/json
import src/validation/request_port

type CartItemAddUsecase* = proc(jsonNode: JsonNode): ShoppingCart

type 
  QueryService = ref object
  CartItemAddUsecaseWithQueryService* = ref object
    queryService: QueryService

generateUnMarshal(ShoppingCartItem)

proc cartItemAddUsecase*(jsonNode: JsonNode): ShoppingCart =
  let cart = newShoppingCart()
  let item = unmarshal(jsonNode, ShoppingCartItem)
  cart.add(item)


proc invoke*(self: CartItemAddUsecaseWithQueryService, jsonNode: JsonNode): ShoppingCart =
  let cart = newShoppingCart()
  let item = unmarshal(jsonNode, ShoppingCartItem)
  cart.add(item)
