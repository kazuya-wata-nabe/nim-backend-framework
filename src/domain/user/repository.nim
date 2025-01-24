import ./model

export model


type ListParams* = ref object
  name: string


type UserListEvent* = proc(params: ListParams): seq[User]

type UserRepository* = tuple
  list: proc(params: ListParams): seq[User]{.gcsafe.}
  save: proc(user: User): void
