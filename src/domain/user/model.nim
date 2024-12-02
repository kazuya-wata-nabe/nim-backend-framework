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
  id: string
  name: Username


func newUser*(name: string): User =
  User(id: "1", name: newUserName name)


func id*(self: User): string = self.id
func name*(self: User): Username = self.name

when isMainModule:
  let user = newUser("hoge")
  echo (%* user)
