import std/json

type 
  Book* = ref object
    name*: string
  BookReadModel* = ref object
    id*: int64
    name*: string

  BookCreateCommand = proc(book: Book): void{.gcsafe.}

  BookCreateUsecase* = ref object
    command*: BookCreateCommand


proc invoke*(self: BookCreateUsecase, body: string): void = 
  let jsonNode = json.parseJson(body)
  let book = jsonNode.to(Book)
  self.command(book)
