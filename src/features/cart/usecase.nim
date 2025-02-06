import std/json

import src/validation/request_port
import ./model

type 
  QueryService = ref object
    cart: ShoppingCart
  CartItemAddUsecase* = ref object
    queryService: QueryService
  ShoppingCartOutDto = JsonNode


func new*(_: type CartItemAddUsecase): CartItemAddUsecase =
  CartItemAddUsecase()

func new*(_: type CartItemAddUsecase, queryService: QueryService): CartItemAddUsecase =
  CartItemAddUsecase(queryService: queryService)

generateUnMarshal(ShoppingCartItem)


proc invoke*(self: CartItemAddUsecase, jsonNode: JsonNode): void =
  let cart = self.queryService.cart
  let item = unmarshal(jsonNode, ShoppingCartItem)
  self.queryService.cart = cart.add(item)
