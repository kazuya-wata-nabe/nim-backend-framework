import src/domain/user/usecase/list

import src/controller/shared

type UserController* = ref object 
  list: ListUsecase


func newUserController*(list: ListUsecase): UserController =
  UserController(list: list)


template fetchUsers*(self, req: untyped): untyped =
  let data = self.list.invoke(convertBodyToJson req.body)
  req.json(Http200, data)


# func fetchUser*(id: string): User =
#   newUser(name = "tom")
