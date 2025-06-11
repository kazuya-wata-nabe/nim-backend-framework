import std/options
import std/sugar

type 
  Book* = ref object
    name*: string
  BookReadModel* = ref object
    id*: int64
    name*: string

  GetBooks = proc(): seq[BookReadModel]{.gcsafe.}
  BookGetCommand = proc(id: int64): Option[BookReadModel]{.gcsafe.}
  BookCreateCommand = proc(book: Book): void{.gcsafe.}
  BookUpdateCommand = proc(id: string, book: Book): void{.gcsafe.}
  BookDeleteCommand = proc(id: string): void{.gcsafe.}

  BookListUsecase* = ref object
    query*: GetBooks
  BookReadUsecase* = ref object
    query*: BookGetCommand
  BookCreateUsecase* = ref object
    command*: BookCreateCommand
  BookUpdateUsecase* = ref object
    command*: BookGetCommand
  BookDeleteUsecase* = ref object
    command*: BookCreateCommand

  BookRepositoryOnMemory = ref object
    items: seq[BookReadModel]

func to(book: Book): BookReadModel =
  BookReadModel(id: 1, name: book.name)

func newBookGetUsecase*(query: BookGetCommand): BookReadUsecase =
  BookReadUsecase(query: query)


func newBookRepositoryOnMemory*(): BookRepositoryOnMemory =
  BookRepositoryOnMemory(
    items: @[
      BookReadModel(id: 1, name: "aaa"),
      BookReadModel(id: 2, name: "bbbb"),
    ]
  )

proc list*(self: BookRepositoryOnMemory): GetBooks =
  () => self.items

proc save*(self: BookRepositoryOnMemory): BookCreateCommand =
  (book: Book) => self.items.add(book.to())


func newBookListUsecase*(query: GetBooks): BookListUsecase =
  BookListUsecase(query: query)

func newBookCreateUsecase*(command: BookCreateCommand): BookCreateUsecase =
  BookCreateUsecase(command: command)

proc invoke*(self: BookListUsecase): seq[BookReadModel] = 
  self.query()

proc invoke*(self: BookReadUsecase, id: int64): Option[BookReadModel] = 
  self.query(id)

proc invoke*(self: BookCreateUsecase, book: Book): void = 
  self.command(book)
