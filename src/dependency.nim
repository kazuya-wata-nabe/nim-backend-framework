import src/features/book/list/pure
import src/features/book/list/controller

type 
  Dependency = ref object
    bookListController*: BookListController


proc newDependency*(): Dependency =
  Dependency(
    bookListController: 
      newBookListRepository().
      newBookListUsecase().
      newBookListController(),
  )
