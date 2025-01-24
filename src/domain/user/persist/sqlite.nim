import std/json

import src/domain/user/repository
import src/db/conn


type UserRepositoryOnSqlite* = ref object
  dbConn: DbConn


proc list(self: UserRepositoryOnSqlite, params: ListParams): seq[User] =
  for record in self.dbConn.selectAll(User()):
    result.add to(record, User)

proc save(self: UserRepositoryOnSqlite, user: User) =
  discard self.dbConn.create(user)


proc toInterface*(self: UserRepositoryOnSqlite): UserRepository =
  return (
    list: proc(params: ListParams): seq[User] = self.list(params),
    save: proc(user: User) = self.save(user)
  )


proc newUserRepository*(dbconn: DbConn): UserRepository = 
  UserRepositoryOnSqlite(dbConn: dbConn).toInterface()


when isMainModule:
  withOnMemoryDb db:
    let r = newUserRepository(db)
    r.save(newUser("test2"))
  
    let users = r.list(ListParams())
    for user in users:
      echo user.name
