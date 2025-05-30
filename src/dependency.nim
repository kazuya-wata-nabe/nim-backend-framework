import src/features/book/list/pure
import src/features/book/list/controller

type 
  Dependency* = ref object
    bookListController*: BookListController


proc newDependency*(): Dependency =
  let bookRepository = newBookListRepositoryOnMemory()
  Dependency(
    bookListController: 
      bookRepository.list().
      newBookListUsecase().
      newBookListController(),
  )
