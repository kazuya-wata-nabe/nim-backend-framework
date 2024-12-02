import std/json
import std/os

import src/domain/user/repository


type UserJsonRepository* = ref object

proc newUserJsonRepository*(): UserJsonRepository = UserJsonRepository()


func list(self: UserJsonRepository, params: ListParams): seq[User] =
  @[
    newUser("test1"),
    newUser("test2"),
    newUser("test3"),
  ]

proc save(self: UserJsonRepository, user: User) =
  let userJson = %*{
    "id": user.id,
    "name": user.name,
  }

  let path = getCurrentDir() & "/db.json"
  let f = open(path, fmWrite)
  f.write(userJson.pretty())
  f.close()


proc toInterface*(self: UserJsonRepository): UserRepository =
  return (
    list: proc(params: ListParams): seq[User] = self.list(params),
    save: proc(user: User) = self.save(user)
  )


when isMainModule:
  discard
