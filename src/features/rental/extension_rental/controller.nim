import src/shared/controller
import ./pure


type 
  RentalExtensionController* = ref object
    usecase: BookListUsecase


func newRentalExtensionController*(usecase: BookListUsecase): RentalExtensionController =
  RentalExtensionController(usecase: usecase)


proc handleRequest*(self: RentalExtensionController, req: Request): Future[void] =
  let data = self.usecase.invoke()
  req.json(Http200, data)
