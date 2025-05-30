import std/options
import std/sugar

type 
  Book* = ref object
    name*: string
  BookReadModel* = ref object
    id*: int64
    name*: string

  BookListCommand = proc(): seq[BookReadModel]{.gcsafe.}
  BookGetCommand = proc(id: int64): Option[BookReadModel]{.gcsafe.}

  BookListUsecase* = ref object
    query: BookListCommand
  BookGetUsecase* = ref object
    query: BookGetCommand

  BookListRepositoryOnMemory = ref object
    items: seq[BookReadModel]

func newBookGetUsecase*(query: BookGetCommand): BookGetUsecase =
  BookGetUsecase(query: query)


func newBookListRepositoryOnMemory*(): BookListRepositoryOnMemory =
  BookListRepositoryOnMemory(
    items: @[
      BookReadModel(id: 1, name: "aaa"),
      BookReadModel(id: 2, name: "bbbb"),
    ]
  )

proc list*(self: BookListRepositoryOnMemory): BookListCommand =
  () => self.items


func newBookListUsecase*(query: BookListCommand): BookListUsecase =
  BookListUsecase(query: query)

proc invoke*(self: BookListUsecase): seq[BookReadModel] = 
  self.query()

proc invoke*(self: BookGetUsecase, id: int64): Option[BookReadModel] = 
  self.query(id)