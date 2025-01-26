import std/json
import src/domain/user/[model, repository]

export model.User

type ListUsecase* = ref object
  repository: UserRepository

func newListUsecase*(repository: UserRepository): ListUsecase =
  ListUsecase(repository: repository)


proc invoke*(self: ListUsecase, params: JsonNode): seq[User] = 
  let query = ListParams()
  self.repository.list(query)