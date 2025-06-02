import src/shared/controller
import src/features/book/pure


type 
  BookCreateController* = ref object
    usecase: BookCreateUsecase

func newBookCreateController*(usecase: BookCreateUsecase): BookCreateController =
  BookCreateController(usecase: usecase)


proc invoke*(self: BookCreateController, body: string): seq[BookReadModel] =
  let book = body.convertBodyToJson().to(Book)
  self.usecase.invoke(book)