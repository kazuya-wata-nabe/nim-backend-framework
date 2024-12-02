import src/domain/user/model

export `%`

func fetchUsers*(): seq[User] =
  @[
    newUser(name = "foo"),
    newUser(name = "bar"),
    newUser(name = "bob"),
  ]

func fetchUser*(id: string): User =
  newUser(name = "tom")
