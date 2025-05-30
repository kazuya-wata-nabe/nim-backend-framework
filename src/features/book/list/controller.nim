import src/shared/controller
import src/features/book/list/pure
import ./pure


type 
  BookListController* = ref object
    usecase: BookListUsecase

func newBookListController*(usecase: BookListUsecase): BookListController =
  BookListController(usecase: usecase)


proc invoke*(self: BookListController): seq[BookReadModel] =
  self.usecase.query()