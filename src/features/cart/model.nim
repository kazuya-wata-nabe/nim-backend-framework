import std/sequtils

type ShoppingCartItem* = ref object
  productId: int64
  amount: uint16

type ShoppingCart* = ref object
  items: seq[ShoppingCartItem]


type CartItemAddEvent = proc(item: ShoppingCartItem): ShoppingCart


func newShoppingCart*(): ShoppingCart = ShoppingCart(items: @[])

func add*(self: ShoppingCart, item: ShoppingCartItem): ShoppingCart =
  ShoppingCart(
    items: self.items.concat(@[item])
  )
