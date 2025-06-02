import std/strutils
import std/sequtils
import std/htmlgen

import src/features/book/pure
import src/features/book/list/controller
import src/features/book/create/controller

proc toRecord(item: BookReadModel): string =
  [
    "<td>" & $item.id & "</td>",
    "<td>" & item.name & "</td>",
  ].join("")

proc list*(controller: BookListController): string = 
  let items = controller.invoke()
  table(
    thead(
      tr(
        "<th>id</th>",
        "<th>name</th>",
      )
    ),
    tbody(
      items.mapIt(
        tr(
          it.toRecord()
        )
      ).join("")
    )
  )

proc create*(controller: BookCreateController): string = 
  """
  <form action=/books/create method=POST>
    name<input name=name >
  </form>
  """
