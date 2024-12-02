import std/json
import std/options
import std/strutils
import std/macros

type InValidForm* = ref object
  errors: seq[string]


type Form*[T] = tuple
  valid: Option[T]
  invalid: Option[InValidForm]


func newInValidForm*(T: typedesc, errors: seq[string]): Form[T] =
  (none(T), some InValidForm(errors: errors))

func newValidForm*[T](val: sink T): Form[T] =
  (some val, none(InValidForm))

func getStrByKey*(n: JsonNode, key: string, default: string = ""): string =
  if n.hasKey(key):
    n[key].getStr()
  else:
    default

func getInt*(n: JsonNode, key: string, default: int = 0): int =
  if n.hasKey(key):
    n[key].getInt()
  else:
    default

proc convertBodyToJson*(body: string): JsonNode =
  try:
    parseJson body
  except:
    %* {}

func getErrors*(invalid: Option[InValidForm]): string =
  if invalid.isSome:
    result = invalid.get.errors.join(", ")
