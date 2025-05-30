import std/strutils
import std/sequtils
import std/htmlgen

import src/features/book/list/pure
import src/features/book/list/controller

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
