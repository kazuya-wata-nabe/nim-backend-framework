import std/json

type Username = distinct string

func `$`*(self: Username): string = self.string
func `%`*(self: Username): JsonNode = newJString(string self)
func `==`*(a: Username, b: Username): bool{.borrow.}

func newUserName(value: string): Username =
  if value.len > 50:
    raise newException(ValueError, "")
  else:
    Username value


type User* = ref object
  id: int64
  name: Username

func tableName*(self: User): string = "users"

func newUser*(name: string): User =
  User(name: newUserName name)


func id*(self: User): int64 = self.id
func name*(self: User): Username = self.name

when isMainModule:
  let user = newUser("hoge")
  echo ( %* user)
