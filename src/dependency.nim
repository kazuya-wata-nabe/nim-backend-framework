import src/features/book/pure
import src/features/book/list/controller
import src/features/book/create/controller

type 
  Dependency* = ref object
    bookListController*: BookListController
    bookCreateController*: BookCreateController


proc newDependency*(): Dependency =
  let bookRepository = newBookRepositoryOnMemory()
  Dependency(
    bookListController: 
      bookRepository.list().
      newBookListUsecase().
      newBookListController(),
    bookCreateController: 
      bookRepository.save().
      newBookCreateUsecase().
      newBookCreateController(),
  )
