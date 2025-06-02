import src/shared/controller
import src/features/book/create/pure
import ./pure


type 
  BookCreateController* = ref object
    usecase: BookCreateUsecase

func newBookCreateController*(usecase: BookCreateUsecase): BookCreateController =
  BookCreateController(usecase: usecase)


proc invoke*(self: BookCreateController): seq[BookReadModel] =
  self.usecase.query()