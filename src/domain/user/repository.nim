import ./model

export model


type ListParams* = ref object
  name: string


type UserListEvent* = proc(params: ListParams): seq[User]

type UserRepository*{.byref.} = ref tuple
  list: proc(params: ListParams): seq[User]
  save: proc(user: User): void
