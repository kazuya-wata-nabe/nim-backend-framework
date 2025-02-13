import std/asynchttpserver
import std/asyncdispatch

import src/features/book/list/pure
import src/features/book/list/controller

type 
  Dependency = ref object
    bookListController: BookListController


proc newDependency*(): Dependency =
  Dependency(
    bookListController: 
      newBookListRepository().
      newBookListUsecase().
      newBookListController()
  )

proc bookListController*(self: Dependency, req: Request): Future[void] =
  self.bookListController.handleRequest(req)