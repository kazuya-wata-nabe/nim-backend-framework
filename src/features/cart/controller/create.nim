# proc postShoppingCart*(usecase: CartItemAddUsecase, req: Request): Future[void]{.async.} =
#   # let data = convertBodyToJson req.body |> usecase
#   let data = usecase (convertBodyToJson req.body)
#   await req.json(Http200, "ok")
