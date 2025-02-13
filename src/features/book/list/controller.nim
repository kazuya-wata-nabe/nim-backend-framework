import src/shared/controller
import ./pure


type 
  BookListController* = ref object
    usecase: BookListUsecase

func newBookListController*(usecase: BookListUsecase): BookListController =
  BookListController(usecase: usecase)


proc handleRequest*(self: BookListController, req: Request): Future[void] =
  let data = self.usecase.invoke()
  req.json(Http200, data)
