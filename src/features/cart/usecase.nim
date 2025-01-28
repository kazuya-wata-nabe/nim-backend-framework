import ./model
import std/json
import src/validation/request_port

type CartItemAddUsecase* = proc(jsonNode: JsonNode): ShoppingCart

generateUnMarshal(ShoppingCartItem)

proc cartItemAddUsecase*(jsonNode: JsonNode): ShoppingCart =
  let cart = newShoppingCart()
  let item = unmarshal(jsonNode, ShoppingCartItem)
  cart.add(item)
