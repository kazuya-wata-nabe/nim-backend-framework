import std/json
import src/domain/user/usecase/list

export `%`


proc fetchUsers*(usecase: ListUsecase, req: string): seq[User] =
  usecase.invoke(parseJson req)

# func fetchUser*(id: string): User =
#   newUser(name = "tom")
