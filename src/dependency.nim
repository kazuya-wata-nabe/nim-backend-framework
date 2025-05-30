import std/asynchttpserver
import std/asyncdispatch

import src/features/book/list/pure
import src/features/book/list/controller
import src/features/rental/extension_rental/pure
import src/features/rental/extension_rental/controller

type 
  Dependency = ref object
    bookListController: BookListController
    rentalPutController: RentalExtensionController


proc newDependency*(): Dependency =
  let bookRepository = newBookListRepository()

  Dependency(
    bookListController: 
      bookRepository.
      newBookListUsecase().
      newBookListController(),

    rentalPutController: 
      newRentalRepository().
      newRentalUsecase().
      newRentalExtensionController(),
  )

proc bookListController*(self: Dependency, req: Request): Future[void] =
  self.bookListController.handleRequest(req)

proc rentalPutController*(self: Dependency, req: Request): Future[void] =
  self.bookListController.handleRequest(req)