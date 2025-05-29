import std/options
import src/shared/controller
import ./pure


type 
  RentalExtensionController* = ref object
    usecase: RentalUsecase


func newRentalExtensionController*(usecase: RentalUsecase): RentalExtensionController =
  RentalExtensionController(usecase: usecase)


proc handleRequest*(self: RentalExtensionController, req: Request): Future[void] =
  let id = 1.uint
  let data = self.usecase.invoke(id)
  if data.isSome():
    req.json(Http200, "ok")
  else:
    req.json(Http409, "ng")
