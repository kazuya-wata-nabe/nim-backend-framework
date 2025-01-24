import std/json
import src/domain/user/[model, repository]

export model.User

type ListUsecase* = ref object
  repository: UserListEvent

func newListUsecase*(repository: UserListEvent): ListUsecase =
  ListUsecase(repository: repository)

proc invoke*(self: ListUsecase, params: ListParams): seq[User] = 
  self.repository.list(params)

proc invoke*(self: ListUsecase, params: JsonNode): seq[User] = 
  # let listParams = to(params, ListParams)
  self.invoke(ListParams())

proc invoke*(self: ListUsecase, params: string): seq[User] = 
  self.invoke(parseJson params)