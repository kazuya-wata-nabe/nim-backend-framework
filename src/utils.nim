import std/os
import std/strutils
import std/json

export json

type Settings* = ref object
  port: uint


func newSettings*(params: seq[string] = @[]): Settings =
  result = Settings(port: 5000)

  for i, param in params:
    if param == "--port" and params.len >= i + 1:
      result.port = parseUInt params[i + 1]


func port*(self: Settings): uint16 =
  self.port.uint16
