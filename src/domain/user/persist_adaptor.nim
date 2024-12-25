import std/json
import std/os

import src/domain/user/repository
import src/domain/json_repository_adaptor


type UserJsonRepository* = ref object

proc newUserJsonRepository*(): UserJsonRepository = UserJsonRepository()


proc list(self: UserJsonRepository, params: ListParams): seq[User] =
  let users = readJson(User())
  for user in users:
    result.add to(user, User)

proc save(self: UserJsonRepository, user: User) =
  writeJson(user)


proc toInterface*(self: UserJsonRepository): UserRepository =
  return (
    list: proc(params: ListParams): seq[User] = self.list(params),
    save: proc(user: User) = self.save(user)
  )


when isMainModule:
  UserJsonRepository().save(newUser("test2"))
  let users = UserJsonRepository().list(ListParams())
  for user in users:
    echo user.name
