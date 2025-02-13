type 
  BookReadModel = ref object
    id: int64
    name: string
  BookListRepository = ref object
    items: seq[BookReadModel]
  BookListUsecase* = ref object
    repository: BookListRepository
  BookGetUsecase* = ref object
    repository: BookListRepository


func newBookListUsecase*(repository: BookListRepository): BookListUsecase =
  BookListUsecase(repository: repository)

func newBookGetUsecase*(repository: BookListRepository): BookGetUsecase =
  BookGetUsecase(repository: repository)

func newBookListRepository*(): BookListRepository =
  BookListRepository(
    items: @[
      BookReadModel(id: 1, name: "aaa"),
      BookReadModel(id: 2, name: "bbbb"),
    ]
  )

proc list(self: BookListRepository): seq[BookReadModel] =
  self.items


proc read(self: BookListRepository, id: int64): BookReadModel =
  for item in self.items:
    if item.id == id:
      result = item
      break


proc invoke*(self: BookListUsecase): seq[BookReadModel] = 
  self.repository.list()

proc invoke*(self: BookGetUsecase, id: int64): BookReadModel = 
  self.repository.read(id)