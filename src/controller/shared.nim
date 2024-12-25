import std/json
import std/options
import std/strutils
import std/macros

type InValidForm* = ref object
  errors: seq[string]


type Form*[T] = tuple
  valid: Option[T]
  invalid: Option[InValidForm]

