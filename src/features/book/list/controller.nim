import src/features/book/pure


type 
  BookListController* = ref object
    usecase: BookListUsecase

func newBookListController*(usecase: BookListUsecase): BookListController =
  BookListController(usecase: usecase)


proc invoke*(self: BookListController): seq[BookReadModel] =
  self.usecase.query()