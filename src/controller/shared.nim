import std/json
import std/options

type InValidForm* = ref object
  errors: seq[string]


type Form*[T] = tuple
  valid: Option[T]
  invalid: Option[InValidForm]


proc convertBodyToJson*(body: string): JsonNode =
  try:
    parseJson body
  except:
    %* {}
