import ./model

export model


type ListParams* = ref object
  name: string


type UserRepository* = tuple
  list: proc(params: ListParams): seq[User]
  save: proc(user: User): void
